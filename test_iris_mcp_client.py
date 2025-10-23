#!/usr/bin/env python3
"""
Test IRIS MCP Server as a client
This script connects to the IRIS MCP HTTP server and tests the tools
"""

import asyncio
import httpx
import json
from typing import Any, Dict, List

# Configuration
MCP_SERVER_URL = "https://trustypa.brainaihub.tech/mcp"
API_KEY = "EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ"

class IRISMCPClient:
    """Simple MCP HTTP client for IRIS"""
    
    def __init__(self, base_url: str, api_key: str):
        self.base_url = base_url
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }
        self.client = httpx.AsyncClient(timeout=30.0)
    
    async def __aenter__(self):
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        await self.client.aclose()
    
    async def list_tools(self) -> List[Dict[str, Any]]:
        """List all available tools"""
        response = await self.client.get(
            f"{self.base_url}/tools",
            headers=self.headers
        )
        response.raise_for_status()
        data = response.json()
        return data.get("tools", [])
    
    async def call_tool(self, tool_name: str, arguments: Dict[str, Any]) -> Dict[str, Any]:
        """Call a specific tool"""
        payload = {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "tools/call",
            "params": {
                "name": tool_name,
                "arguments": arguments
            }
        }
        
        response = await self.client.post(
            f"{self.base_url}/message",
            headers=self.headers,
            json=payload
        )
        response.raise_for_status()
        return response.json()
    
    async def health_check(self) -> Dict[str, Any]:
        """Check server health (no auth required)"""
        response = await self.client.get(f"{self.base_url}/health")
        response.raise_for_status()
        return response.json()


async def main():
    """Test IRIS MCP server"""
    
    print("=" * 80)
    print("🧪 IRIS MCP Client Test")
    print("=" * 80)
    print()
    
    async with IRISMCPClient(MCP_SERVER_URL, API_KEY) as client:
        
        # Test 1: Health Check (no auth)
        print("📋 Test 1: Health Check")
        try:
            health = await client.health_check()
            print(f"✅ Server Status: {health.get('status', 'unknown')}")
        except Exception as e:
            print(f"❌ Health check failed: {e}")
        print()
        
        # Test 2: List Tools
        print("📋 Test 2: List Available Tools")
        try:
            tools = await client.list_tools()
            print(f"✅ Found {len(tools)} tools:")
            for tool in tools:
                name = tool.get('name', 'unknown')
                desc = tool.get('description', 'No description')
                print(f"   • {name}: {desc[:60]}...")
        except Exception as e:
            print(f"❌ List tools failed: {e}")
        print()
        
        # Test 3: Check OAuth Status
        print("📋 Test 3: Check OAuth Status")
        try:
            result = await client.call_tool(
                "oauth_check_status",
                {"user_email": "yyi9910@infocert.it"}
            )
            print(f"✅ OAuth Status Response:")
            print(f"   {json.dumps(result, indent=2)}")
        except Exception as e:
            print(f"❌ OAuth check failed: {e}")
        print()
        
        # Test 4: Get OAuth Login URL
        print("📋 Test 4: Get OAuth Login URL")
        try:
            result = await client.call_tool(
                "oauth_get_login_url",
                {}
            )
            print(f"✅ Login URL Response:")
            print(f"   {json.dumps(result, indent=2)}")
        except Exception as e:
            print(f"❌ Get login URL failed: {e}")
        print()
        
        # Test 5: Search User (requires OAuth)
        print("📋 Test 5: Search User in Directory")
        try:
            result = await client.call_tool(
                "users_search",
                {
                    "user_email": "yyi9910@infocert.it",
                    "query": "test"
                }
            )
            print(f"✅ User Search Response:")
            print(f"   {json.dumps(result, indent=2)}")
        except Exception as e:
            print(f"⚠️  User search failed (expected if not logged in): {e}")
        print()
    
    print("=" * 80)
    print("🎉 Test Complete!")
    print("=" * 80)


if __name__ == "__main__":
    asyncio.run(main())
