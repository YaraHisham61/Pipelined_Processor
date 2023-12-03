import random

# Function to generate a random 16-bit binary number
def generate_binary():
    return bin(random.randint(0, 2**16 - 1))[2:].zfill(16)

# Number of lines to generate
num_lines = 4000

# File path
file_path = "data.txt"

# Generate and write binary numbers to the file
with open(file_path, 'w') as file:
    for _ in range(num_lines):
        binary_number = generate_binary()
        file.write(binary_number + '\n')

print(f"{num_lines} lines of 16-bit binary numbers have been written to {file_path}.")