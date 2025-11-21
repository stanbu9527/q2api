# -*- coding: utf-8 -*-
"""
Test script for console authentication
"""
import os
import httpx
import asyncio

BASE_URL = os.getenv("TEST_BASE_URL", "http://localhost:8000")
CONSOLE_PASSWORD = os.getenv("CONSOLE_PASSWORD", "")

async def test_console_auth():
    """Test console authentication"""
    async with httpx.AsyncClient() as client:
        print(f"Testing console authentication at {BASE_URL}")
        print(f"Console password configured: {'Yes' if CONSOLE_PASSWORD else 'No'}")
        print("-" * 60)
        
        # Test 1: Access without password
        print("\n[Test 1] Access /v2/accounts without password")
        try:
            r = await client.get(f"{BASE_URL}/v2/accounts")
            if r.status_code == 401:
                print("✓ Correctly rejected (401 Unauthorized)")
            elif r.status_code == 200:
                if CONSOLE_PASSWORD:
                    print("✗ SECURITY ISSUE: Should require password but didn't!")
                else:
                    print("✓ Access granted (no password configured)")
            else:
                print(f"? Unexpected status: {r.status_code}")
        except Exception as e:
            print(f"✗ Error: {e}")
        
        # Test 2: Access with wrong password
        if CONSOLE_PASSWORD:
            print("\n[Test 2] Access with wrong password")
            try:
                r = await client.get(
                    f"{BASE_URL}/v2/accounts",
                    headers={"X-Console-Password": "wrong_password"}
                )
                if r.status_code == 401:
                    print("✓ Correctly rejected wrong password")
                else:
                    print(f"✗ SECURITY ISSUE: Wrong password accepted! Status: {r.status_code}")
            except Exception as e:
                print(f"✗ Error: {e}")
        
        # Test 3: Access with correct password
        if CONSOLE_PASSWORD:
            print("\n[Test 3] Access with correct password")
            try:
                r = await client.get(
                    f"{BASE_URL}/v2/accounts",
                    headers={"X-Console-Password": CONSOLE_PASSWORD}
                )
                if r.status_code == 200:
                    print("✓ Access granted with correct password")
                    data = r.json()
                    print(f"  Retrieved {len(data)} accounts")
                else:
                    print(f"✗ Failed with status: {r.status_code}")
            except Exception as e:
                print(f"✗ Error: {e}")
        
        # Test 4: Homepage access
        print("\n[Test 4] Access homepage /")
        try:
            headers = {}
            if CONSOLE_PASSWORD:
                headers["X-Console-Password"] = CONSOLE_PASSWORD
            
            r = await client.get(f"{BASE_URL}/", headers=headers)
            if r.status_code == 200:
                print("✓ Homepage accessible")
            elif r.status_code == 401:
                print("✗ Homepage blocked (check if password is required)")
            else:
                print(f"? Unexpected status: {r.status_code}")
        except Exception as e:
            print(f"✗ Error: {e}")
        
        # Test 5: API endpoint (should not require console password)
        print("\n[Test 5] Access API endpoint /healthz (should not require console password)")
        try:
            r = await client.get(f"{BASE_URL}/healthz")
            if r.status_code == 200:
                print("✓ API endpoint accessible without console password")
            else:
                print(f"✗ Unexpected status: {r.status_code}")
        except Exception as e:
            print(f"✗ Error: {e}")
        
        print("\n" + "=" * 60)
        print("Test completed")

if __name__ == "__main__":
    asyncio.run(test_console_auth())
