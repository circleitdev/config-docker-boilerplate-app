# traefik v0.1.1

A brief configurations for this project and its setup preparation.

## Installation

```bash
$ tobemodified
```

## Configuration

replace billy needs:

```bash
+ find stuff TOBEMODIFIED
```

generate password auth for initial user:

```bash
$ htpasswd -Bc registry.password username
```

generate password auth for next user:

```bash
$ htpasswd -B registry.password username
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
