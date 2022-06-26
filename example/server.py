import asyncio
import logging

from aiotftp import Server, FileResponse, Response


async def read(request):
    if request.filename == "hello":
        return Response(b"Hello World!" * 1024)
    return FileResponse(request.filename)


async def write(request):
    with open(request.filename, "wb") as fp:
        async for chunk in await request.accept():
            fp.write(chunk)


async def main(loop):
    server = Server(read, write)
    await loop.create_datagram_endpoint(server, local_addr=("0.0.0.0", 69))


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    loop = asyncio.get_event_loop()

    try:
        loop.run_until_complete(main(loop))
        loop.run_forever()
    except KeyboardInterrupt:
        pass
    loop.close()
