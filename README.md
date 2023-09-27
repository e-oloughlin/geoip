# GEOIP lookup service

### Usage

For an IP address of `185.180.241.100`:

```
aws lambda invoke --function-name geoip --cli-binary-format raw-in-base64-out --payload '{"ip": "185.180.241.100"}' response.json
```

followed by:

```
cat response.json | jq
```

outputs something like:

```
{
  "city": {
    "geoname_id": 2965140,
    "names": {
      "de": "Cork",
      "en": "Cork",
      "es": "Cork",
      "fr": "Cork",
      "ja": "コーク",
      "pt-BR": "Cork",
      "ru": "Корк",
      "zh-CN": "科克"
    }
  },
  "continent": {
    "code": "EU",
    "geoname_id": 6255148,
    "names": {
      "de": "Europa",
      "en": "Europe",
      "es": "Europa",
      "fr": "Europe",
      "ja": "ヨーロッパ",
      "pt-BR": "Europa",
      "ru": "Европа",
      "zh-CN": "欧洲"
    }
  },
  "country": {
    "geoname_id": 2963597,
    "is_in_european_union": true,
    "iso_code": "IE",
    "names": {
      "de": "Irland",
      "en": "Ireland",
      "es": "Irlanda",
      "fr": "Irlande",
      "ja": "アイルランド",
      "pt-BR": "Irlanda",
      "ru": "Ирландия",
      "zh-CN": "爱尔兰"
    }
  },
  "location": {
    "accuracy_radius": 1000,
    "latitude": 51.7111,
    "longitude": -8.5317,
    "time_zone": "Europe/Dublin"
  },
  "postal": {
    "code": "P17"
  },
  "registered_country": {
    "geoname_id": 2963597,
    "is_in_european_union": true,
    "iso_code": "IE",
    "names": {
      "de": "Irland",
      "en": "Ireland",
      "es": "Irlanda",
      "fr": "Irlande",
      "ja": "アイルランド",
      "pt-BR": "Irlanda",
      "ru": "Ирландия",
      "zh-CN": "爱尔兰"
    }
  },
  "subdivisions": [
    {
      "geoname_id": 7521315,
      "iso_code": "M",
      "names": {
        "en": "Munster",
        "fr": "Munster",
        "ja": "マンスター",
        "ru": "Манстер",
        "zh-CN": "芒斯特省"
      }
    },
    {
      "geoname_id": 2965139,
      "iso_code": "CO",
      "names": {
        "en": "County Cork"
      }
    }
  ]
}
```

### Continuous integration

1. Every day at 3am, check for an update to Maxmind's mmdb listing
2. Download the update if available
3. Build a new docker image containing the latest mmdb file and push to ECR
4. Create IAM role
5. Deploy lambda using new image from ECR with defined IAM role
