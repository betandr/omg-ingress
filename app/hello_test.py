import base64
import json
import os
import pytest

import hello

@pytest.fixture
def client():
    hello.app.testing = True
    return hello.app.test_client()

def test_index(client):
    r = client.get('/')
    assert r.status_code == 200
