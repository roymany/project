import socket
import asyncio
import websockets
import threading as th

key = "my_Project_123"


def add_song_to_list(song):
    f = open("C:/Users/USER/Desktop/song_users_wants_to_upload.txt", "a")
    f.write("song: " + song + "\r\n")
    f.close()


def xor_encrypt_decrypt(encrypted_text):
    decrypted = []
    for i in range(len(encrypted_text)):
        char_code = ord(encrypted_text[i]) ^ ord(key[i % len(key)])
        decrypted.append(char_code)
    return ''.join(chr(char) for char in decrypted)


async def handle_client(websocket):
    print("--------------------")
    print("Client Connected")
    try:
        async for message in websocket:
            message = xor_encrypt_decrypt(message)
            print(f"Message received: {message}")
            w = th.Thread(target=add_song_to_list, args={message})
            w.start()
    except:
        print("Client Disconnected Prematurely")
        print("--------------------")


async def main():
    print("Server Start")
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    async with websockets.serve(handle_client, ip_address, 8820):
        await asyncio.Future()  # Run forever


if __name__ == "__main__":
    asyncio.run(main())
