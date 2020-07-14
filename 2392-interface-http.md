## Motivation

HTTP services are often chained. Sitting in front of a web application might be a load-balancer and multiple caching services.

## Relation Data

| Key | Set by | Example values |
|------|-------|------|
| hostname | provides | `10.10.0.1`, `app.example.internal` |
| port | provides | `5000` | 


## Conversation

|  | Partner | Event | 
|-------|---------|---|
| 1     | both      | Relation established
| 2     | provides      | relation-set hostname
| 2     | provides      | relation-set port

## Typical endpoint names

provides
- `website`


requires
- `balancer` - [apache2][]
- `website-cache` - [apache2][]
- `reverseproxy` - [haproxy][], [apache2][]
- `cached-website` - [squid-reverseproxy](https://jaas.ai/squid-reverseproxy)

[haproxy]: https://jaas.ai/haproxy
[apache2]: https://jaas.ai/apache2

## Links
- [charms requiring `http`](https://jaas.ai/search?requires=http)
- [charms providing `http`](https://jaas.ai/search?provides=http)
