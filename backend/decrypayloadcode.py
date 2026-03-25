from cryptography.fernet import Fernet
import base64

# Fernet key must be 32-byte base64-encoded
encryption_key = b'mcMAmuM2wLgNey7hgaCXDsaH__h13R2esSQ7fKvX3ak='


def encrypt_data(data: str, key: bytes) -> str:
    """Encrypts and double-base64-encodes the result (as in your original logic)"""
    cipher = Fernet(key)
    encrypted = cipher.encrypt(data.encode('utf-8'))  # Fernet already returns base64
    return base64.b64encode(encrypted).decode('utf-8')  # Second layer of base64


def decrypt_data(data: str, key: bytes) -> str:
    """Decrypts a double-base64-encoded Fernet token"""
    # Fix padding for outer base64
    missing_padding = len(data) % 4
    if missing_padding:
        data += '=' * (4 - missing_padding)

    encrypted_token = base64.b64decode(data)  # decode outer base64
    cipher = Fernet(key)
    decrypted = cipher.decrypt(encrypted_token)  # decrypt inner (Fernet base64)
    return decrypted.decode('utf-8')


if __name__ == "__main__":
    # Example usage:
    encrypted_input = "Z0FBQUFBQnB2VE5Fd0ZYSHVaUFh0UjdsZzZHWXRnQXU0NVJhaU9iNktyREhweEplaG9nNnJxcVlqNVVjam04LV9MT18yZjY3MFlQS25hWlRxdEZVWENtd29LeUR0dk90SzFWNW1fZERrbkctRUpDdENxVHhGN0pKc0FwWDdtOC03d3NoY3VYLW5lY20tcldkbjE4Sk9OSzljYl93bmVFMTBJeV80cmI0NVU0RHZpdHRuZEstTmlseUJCT0dTemlLcXV2MkJLRlY5Vy1pckdtbk9SVVFZMk1maF9KQUNCNko1RXZRSTNMUU1XckdvQU9LTUNPWWt2OHV1RndWUzRhZlliRVRyWHBYRnBJUS1ydTFwVEJaWTI5MExQNHFORU9ueXQyTk9wb3paa0RqcEhtWjBiVnhpVnc9"
    decrypted_output = decrypt_data(encrypted_input, encryption_key)
    print("Decrypted message:", decrypted_output)