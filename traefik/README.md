# traefik

Category of official image / infrastructure service / first party app

## Installation

```bash
$ tobemodified
```

## Configuration

replace belly needs:

```bash
+ find stuff TOBEMODIFIED
```

replace supre needs:

```bash
+ find stuff .example
```

generate password auth for initial user:

```bash
$ htpasswd -Bc traefik.password username
```

generate password auth for next user:

```bash
$ htpasswd -B traefik.password username
```

other:

```bash
$ tobemodified
```

## Development

generate optional self-signed ssl:

```bash
$ mkcert -cert-file certs/cert.pem -key-file certs/key.pem "localhost" "*.docker.localhost"
```

other:

```bash
$ tobemodified
```

## Production

```bash
$ tobemodified
```
