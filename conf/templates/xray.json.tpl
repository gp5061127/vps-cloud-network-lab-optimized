{
    "inbounds": [
        {
            "port": {{port}},
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "{{password}}"
                    }
                ]
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
