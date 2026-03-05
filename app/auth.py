import hashlib
import hmac
import os


def hash_password(password: str, iterations: int = 310000) -> str:
    salt = os.urandom(16).hex()
    dk = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), bytes.fromhex(salt), iterations)
    return f"pbkdf2_sha256${iterations}${salt}${dk.hex()}"


def verify_password(password: str, stored_hash: str) -> bool:
    try:
        algo, iterations_s, salt, digest = stored_hash.split("$", 3)
        if algo != "pbkdf2_sha256":
            return False
        iterations = int(iterations_s)
    except Exception:
        return False

    candidate = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), bytes.fromhex(salt), iterations).hex()
    return hmac.compare_digest(candidate, digest)
