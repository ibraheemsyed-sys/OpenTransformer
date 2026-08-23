import serial
import struct
import time
from serial.tools import list_ports

BAUD = 115200


def choose_port():
    ports = list(list_ports.comports())

    if not ports:
        raise RuntimeError("No serial ports found.")

    if len(ports) == 1:
        print("Using:", ports[0].device)
        return ports[0].device

    print("\nSerial ports:")

    for i, port in enumerate(ports):
        print(f"{i}: {port.device} - {port.description}")

    choice = int(input("\nChoose port: "))
    return ports[choice].device


def get_matrix(name):
    matrix = []

    print(f"\nEnter Matrix {name}")
    print("16 numbers per row, values 0-255")

    for r in range(16):
        while True:
            try:
                row = list(map(int, input(f"{name}[{r}]: ").split()))

                if len(row) != 16:
                    print("Enter exactly 16 numbers.")
                    continue

                if any(x < 0 or x > 255 for x in row):
                    print("Values must be between 0 and 255.")
                    continue

                matrix.append(row)
                break

            except ValueError:
                print("Numbers only.")

    return matrix


def quick_test():
    A = [
        [r + c + 1 for c in range(16)]
        for r in range(16)
    ]

    B = [
        [1 for _ in range(16)]
        for _ in range(16)
    ]

    return A, B


def flatten(matrix):
    return bytes(
        value
        for row in matrix
        for value in row
    )


def software_matmul(A, B):
    return [
        [
            sum(A[r][k] * B[k][c] for k in range(16))
            for c in range(16)
        ]
        for r in range(16)
    ]


def read_exact(ser, count):
    data = bytearray()

    while len(data) < count:
        chunk = ser.read(count - len(data))

        if not chunk:
            raise TimeoutError("FPGA stopped responding.")

        data.extend(chunk)

    return bytes(data)


def wait_for_header(ser):
    end = time.time() + 5

    while time.time() < end:
        value = ser.read(1)

        if value == b"\x5A":
            return

    raise TimeoutError("Did not receive FPGA response header.")


def print_matrix(matrix):
    for row in matrix:
        print(" ".join(f"{value:8}" for value in row))


print("OpenTransformer FPGA Matrix Multiply")

mode = input("\nQuick test or manual matrices? [q/m]: ").strip().lower()

if mode == "m":
    A = get_matrix("A")
    B = get_matrix("B")
else:
    A, B = quick_test()

port = choose_port()

with serial.Serial(port, BAUD, timeout=1) as ser:

    time.sleep(0.2)

    ser.reset_input_buffer()
    ser.reset_output_buffer()

    packet = b"\xA5" + flatten(A) + flatten(B)

    print("\nSending matrices...")

    start_time = time.perf_counter()

    ser.write(packet)
    ser.flush()

    wait_for_header(ser)

    raw = read_exact(ser, 256 * 4)

    elapsed = time.perf_counter() - start_time


values = struct.unpack("<256I", raw)

C = [
    list(values[r * 16:(r + 1) * 16])
    for r in range(16)
]

expected = software_matmul(A, B)

print("\nFPGA result:\n")
print_matrix(C)

if C == expected:
    print("\nPASS - all 256 outputs correct")
else:
    print("\nFAIL - FPGA result differs from Python")

print(f"Total PC-FPGA-PC time: {elapsed * 1000:.2f} ms")