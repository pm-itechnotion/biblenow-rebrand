# BibleNow Rebrand Deployment

This guide will help you clone, configure, and run the BibleNow rebranded Jitsi deployment using Docker.

---

## Prerequisites

* Server with Docker and Docker Compose installed.
* Access to the server terminal.

---

## Installation Steps

1. **Clone the repository**

```bash
git clone https://github.com/pm-itechnotion/biblenow-rebrand.git
cd biblenow-rebrand
```

2. **Set up your environment variables**

```bash
cp env.example .env
# Edit .env to set your custom configuration values
nano .env
```

3. **Start Docker containers**

```bash
docker compose up -d --force-recreate
```

4. **Verify containers are running**

```bash
docker ps
```

You should see output similar to:

```
CONTAINER ID   IMAGE                    COMMAND   CREATED       STATUS       PORTS                                               NAMES
<id>          jitsi/web:unstable       "/init"    1 sec ago    Up 1 sec   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp         biblenow-rebrand-web-1
<id>          jitsi/jicofo:unstable    "/init"    1 sec ago    Up 1 sec   127.0.0.1:8888->8888/tcp                          biblenow-rebrand-jicofo-1
<id>          jitsi/jvb:unstable       "/init"    1 sec ago    Up 1 sec   127.0.0.1:8080->8080/tcp, 0.0.0.0:10000->10000/udp biblenow-rebrand-jvb-1
<id>          jitsi/prosody:unstable   "/init"    1 sec ago    Up 1 sec   0.0.0.0:5222->5222/tcp, 0.0.0.0:5280->5280/tcp    biblenow-rebrand-prosody-1
```

---

## Rebranding Jitsi Interface

1. **Access the web container**

```bash
docker exec -it biblenow-rebrand-web-1 bash
```

2. **Install `nano` editor**

```bash
apt update && apt install nano -y
```

3. **Edit the interface configuration**

```bash
nano /config/interface_config.js
```

Update the following values for BibleNow branding:

```javascript
APP_NAME: 'BibleNow'
BRAND_WATERMARK_LINK: 'https://www.biblenow.com'
DISPLAY_WELCOME_FOOTER: false
JITSI_WATERMARK_LINK: 'https://www.biblenow.com'
MOBILE_APP_PROMO: false
SHOW_BRAND_WATERMARK: true
SHOW_JITSI_WATERMARK: false
```

Save and exit (`Ctrl + O`, `Enter`, `Ctrl + X`).

---

## Access the Application

Open your browser and navigate to:

[https://stream.biblenow.com](https://stream.biblenow.com)

Your rebranded Jitsi instance should now be live.

---

## Notes

* Ensure your domain points to the server running the Docker containers.
* For any changes in branding, always edit `/config/interface_config.js` inside the `web` container.

---

# JVB Docker Server Installation

This guide will help you install and run a Jitsi Video Bridge (JVB) using Docker, rexxu.

---

## Steps to Install JVB Docker

1. **Login to your JVB VM**

```bash
ssh <your-vm-user>@<jvb-vm-ip>
```

2. **Create JVB directory**

```bash
cd /home
mkdir jitsi-jvb
cd jitsi-jvb
```

3. **Create `docker-compose.yml` file**

```bash
sudo nano docker-compose.yml
```

Paste the following content:

```yaml
version: "3"

services:
  jvb:
    image: jitsi/jvb:stable
    restart: unless-stopped
    ports:
      - "10000:10000/udp"    # media (RTP/UDP)
      - "4443:4443/tcp"     # fallback TCP if configured
    environment:
      - XMPP_SERVER=${XMPP_SERVER}
      - XMPP_DOMAIN=${XMPP_DOMAIN}
      - XMPP_AUTH_DOMAIN=${XMPP_AUTH_DOMAIN}
      - XMPP_INTERNAL_MUC_DOMAIN=${XMPP_INTERNAL_MUC_DOMAIN}
      - JVB_AUTH_USER=${JVB_AUTH_USER}
      - JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD}
      - JVB_BREWERY_MUC=${JVB_BREWERY_MUC}
      - JVB_PORT=${JVB_PORT}
      - JVB_TCP_HARVESTER_DISABLED=${JVB_TCP_HARVESTER_DISABLED}
      - JVB_TCP_PORT=${JVB_TCP_PORT}
      - TZ=${TZ}
    volumes:
      - ./jvb-config:/config
```

Save and exit (`Ctrl + O`, `Enter`, `Ctrl + X`).

4. **Set up environment variables**

Create `.env` file with the variables used in `docker-compose.yml`:

```bash
nano .env
```

```env
XMPP_SERVER=xmpp.stream.biblenow.io
XMPP_DOMAIN=stream.biblenow.io
XMPP_AUTH_DOMAIN=auth.stream.biblenow.io
XMPP_INTERNAL_MUC_DOMAIN=internal-muc.stream.biblenow.io
JVB_AUTH_USER=jvb
JVB_AUTH_PASSWORD=f47c076793e8d3dfe42459ab292cf2f0
JVB_BREWERY_MUC=jvbbrewery
JVB_PORT=10000
JVB_TCP_HARVESTER_DISABLED=false
JVB_TCP_PORT=4443
TZ=Asia/Kolkata
```

5. **Start the JVB container**

```bash
docker compose up -d
```

6. **Verify the container is running**

```bash
docker ps
```

You should see the `jitsi/jvb:stable` container running and exposing ports `10000/udp` and `4443/tcp`.

---

Your JVB Docker server is now set up and ready to connect with your Jitsi deployment.



