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
BRAND_WATERMARK_LINK: 'https://www.biblenow.io'
DISPLAY_WELCOME_FOOTER: false
JITSI_WATERMARK_LINK: 'https://www.biblenow.io'
MOBILE_APP_PROMO: false
SHOW_BRAND_WATERMARK: true
SHOW_JITSI_WATERMARK: false
```

Save and exit (`Ctrl + O`, `Enter`, `Ctrl + X`).

---
4. **Execute the following command:**

```bash
sed -i 's|Jitsi Meet|BibleNow|g' /usr/share/jitsi-meet/libs/app.bundle.min.js
```


## Access the Application

Open your browser and navigate to:

[https://stream.biblenow.com](https://stream.biblenow.com)

Your rebranded Jitsi instance should now be live.

---

## Notes

* Ensure your domain points to the server running the Docker containers.
* For any changes in branding, always edit `/config/interface_config.js` inside the `web` container.

---
