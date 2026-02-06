# 🎨 Nova AI Generator - Generatore Completo di Immagini e Video

Soluzione completa per la generazione di contenuti multimediali AI utilizzando Amazon Nova Canvas (immagini) e Amazon Nova Reel (video).

## 📋 Indice

- [Italiano](#italiano)
  - [Funzionalità](#funzionalità)
  - [Architettura](#architettura)
  - [Prerequisiti](#prerequisiti)
  - [Installazione](#installazione)
  - [Configurazione](#configurazione)
  - [Utilizzo](#utilizzo)
  - [Costi](#costi)
- [English](#english)
  - [Features](#features)
  - [Architecture](#architecture-1)
  - [Prerequisites](#prerequisites-1)
  - [Installation](#installation-1)
  - [Configuration](#configuration-1)
  - [Usage](#usage-1)
  - [Costs](#costs-1)

---

## Italiano

### 🚀 Funzionalità

#### Generazione Immagini (Nova Canvas)

**1. Text-to-Image (Testo → Immagine)**
- Genera immagini fotorealistiche da descrizioni testuali
- Ricerca web automatica per migliorare i risultati (opzionale)
- Prompt enhancement con AI per ottimizzare le descrizioni
- Risoluzione: 1280x720 (HD 16:9)
- Qualità: Premium

**2. Image-to-Image (Modifica Immagine)**
- Modifica immagini esistenti con nuove descrizioni
- Upload tramite click o drag & drop
- Ridimensionamento automatico a 1280x720
- Rimozione automatica trasparenza

#### Generazione Video (Nova Reel)

**1. Text-to-Video (Testo → Video)**
- Genera video cinematici da descrizioni testuali
- Durate disponibili: 6, 12, 18 secondi
- Risoluzione: 1280x720 @ 24fps
- Generazione asincrona con progress bar

**2. Image-to-Video (Immagine → Video)**
- Anima immagini statiche con movimento
- Upload con ridimensionamento automatico
- Rimozione trasparenza automatica
- Prompt per descrivere il movimento desiderato

### 🏗️ Architettura

**Componenti AWS:**
- **API Gateway**: Endpoint REST per immagini e video
- **Lambda Functions**: 
  - `NovaIntelligentImageGenerator`: Generazione immagini con AI enhancement
  - `NovaWebSearchFunction`: Ricerca web con Tavily/DuckDuckGo
  - `NovaVideoGenerator`: Avvio generazione video asincrona
  - `NovaVideoStatus`: Polling stato generazione video
- **S3 Bucket**: Storage video con lifecycle 7 giorni
- **Bedrock**: Accesso ai modelli Nova Canvas, Nova Lite, Nova Reel
- **IAM Roles**: Permessi per Lambda e Bedrock

**Modelli AI Utilizzati:**
- `amazon.nova-canvas-v1:0`: Generazione immagini
- `amazon.nova-lite-v1:0`: Enhancement prompt
- `amazon.nova-reel-v1:0`: Generazione video

### 📦 Prerequisiti

- Account AWS attivo
- AWS CLI configurato
- Accesso ai modelli Amazon Nova in AWS Bedrock
- Regione supportata: `us-east-1` (consigliata)
- (Opzionale) Tavily API Key per ricerca web avanzata

### 🔧 Installazione

#### 1. Deploy CloudFormation Stack

```bash
# Clona il repository
git clone <repository-url>
cd nova-ai-generator

# Deploy con AWS CLI
aws cloudformation create-stack \
  --stack-name nova-ai-generator \
  --template-body file://nova-image-generator.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters ParameterKey=TavilyApiKey,ParameterValue=YOUR_API_KEY
```


**Oppure usa lo script di deploy:**

```bash
chmod +x deploy-stack.sh
./deploy-stack.sh
```

#### 2. Ottieni gli Endpoint API

Dopo il deploy, recupera gli endpoint:

```bash
aws cloudformation describe-stacks \
  --stack-name nova-ai-generator \
  --query 'Stacks[0].Outputs'
```

Oppure dalla console AWS CloudFormation → Stack → Tab "Outputs"

### ⚙️ Configurazione

#### 1. Apri l'Interfaccia Web

Apri il file `Nova_Complete_v3_Images_And_Videos.html` nel browser.

#### 2. Configura gli Endpoint

1. Vai nella tab **"⚙️ Endpoint"**
2. Incolla i 3 endpoint ottenuti dal CloudFormation:
   - **Image Generation Endpoint** (da `ApiEndpoint`)
   - **Video Generation Endpoint** (da `VideoApiEndpoint`)
   - **Video Status Endpoint** (da `VideoStatusEndpoint`)
3. Clicca **"💾 Salva Configurazione"**

Gli endpoint vengono salvati nel browser (localStorage) e non serve reinserirli.

### 🎯 Utilizzo

#### Generazione Immagini

**Text-to-Image:**
1. Tab **"📸 Immagini"**
2. Seleziona **"✨ Nuova Immagine"**
3. Inserisci prompt (es. "A futuristic city at sunset")
4. (Opzionale) Abilita ricerca web per risultati migliori
5. Clicca **"🚀 Genera Immagine"**
6. Attendi ~10-15 secondi
7. Scarica con **"💾 Scarica"**

**Image-to-Image:**
1. Tab **"📸 Immagini"**
2. Seleziona **"🖼️ Modifica Immagine"**
3. Carica immagine (click o drag & drop)
4. Inserisci prompt di modifica
5. Clicca **"🚀 Genera Immagine"**


#### Generazione Video

**Text-to-Video:**
1. Tab **"🎬 Video"**
2. Seleziona **"✨ Testo → Video"**
3. Scegli durata (6/12/18 secondi)
4. Inserisci prompt (es. "Ocean waves crashing on beach")
5. Clicca **"🎬 Genera Video"**
6. Attendi (~90s per 6 secondi, ~3min per 12s, ~4.5min per 18s)
7. Scarica con **"💾 Scarica Video"**

**Image-to-Video:**
1. Tab **"🎬 Video"**
2. Seleziona **"🖼️ Immagine → Video"**
3. Carica immagine da animare
4. Scegli durata
5. Inserisci prompt movimento (es. "Camera slowly zooms in")
6. Clicca **"🎬 Genera Video"**

### 💰 Costi

**Costi AWS stimati (us-east-1):**

- **Nova Canvas (Immagini)**:
  - Text-to-Image: ~$0.04 per immagine
  - Image-to-Image: ~$0.04 per immagine

- **Nova Reel (Video)**:
  - 6 secondi: ~$0.30 per video
  - 12 secondi: ~$0.60 per video
  - 18 secondi: ~$0.90 per video

- **Lambda**: ~$0.0000002 per richiesta (praticamente gratuito)
- **API Gateway**: ~$0.0000035 per richiesta
- **S3**: ~$0.023 per GB/mese (video eliminati dopo 7 giorni)

**Nota**: I prezzi sono indicativi e possono variare. Consulta [AWS Pricing](https://aws.amazon.com/pricing/) per dettagli aggiornati.

### 🔒 Sicurezza

- CORS configurato per accesso pubblico (`*`)
- Nessuna autenticazione richiesta (modifica per produzione)
- Video storage con lifecycle automatico (7 giorni)
- IAM roles con permessi minimi necessari


### 🛠️ Personalizzazione

#### Modifica Risoluzione Immagini

Attualmente solo 1280x720 è supportato da Nova Canvas. Per altre risoluzioni, modifica il CloudFormation template (nota: potrebbero non funzionare).

#### Aggiungi Autenticazione

Per produzione, aggiungi:
- API Gateway Authorizer (Lambda/Cognito)
- Modifica CORS per domini specifici
- Rate limiting

#### Cambia Durata Video

Modifica il file HTML, sezione durata:
```html
<option value="6">6 secondi</option>
<option value="12">12 secondi</option>
<option value="18">18 secondi</option>
```

### 📝 Limitazioni

- **Immagini**: Solo risoluzione 1280x720
- **Video**: Solo risoluzioni 1280x720, durate multiple di 6 secondi
- **Testo nelle immagini**: Nova Canvas non può generare testo leggibile
- **Trasparenza**: Non supportata nei video (rimossa automaticamente)
- **Video-to-Video**: Non supportato da Nova Reel

### 🐛 Troubleshooting

**Errore: "ValidationException: dimensions"**
- L'immagine viene ridimensionata automaticamente, verifica il browser

**Errore: "ValidationException: transparency"**
- La trasparenza viene rimossa automaticamente, verifica il browser

**Video non si genera:**
- Verifica endpoint nella tab Endpoint
- Controlla CloudWatch Logs per errori Lambda
- Verifica permessi IAM per Bedrock

**Ricerca web non funziona:**
- Fallback automatico a DuckDuckGo se Tavily non disponibile
- Verifica connessione internet

### 📄 Licenza

MIT License - Vedi file LICENSE

### 🤝 Contributi

Contributi benvenuti! Apri una issue o pull request.

---


## English

### 🚀 Features

#### Image Generation (Nova Canvas)

**1. Text-to-Image**
- Generate photorealistic images from text descriptions
- Automatic web search to improve results (optional)
- AI-powered prompt enhancement
- Resolution: 1280x720 (HD 16:9)
- Quality: Premium

**2. Image-to-Image (Image Editing)**
- Modify existing images with new descriptions
- Upload via click or drag & drop
- Automatic resize to 1280x720
- Automatic transparency removal

#### Video Generation (Nova Reel)

**1. Text-to-Video**
- Generate cinematic videos from text descriptions
- Available durations: 6, 12, 18 seconds
- Resolution: 1280x720 @ 24fps
- Asynchronous generation with progress bar

**2. Image-to-Video**
- Animate static images with motion
- Upload with automatic resizing
- Automatic transparency removal
- Prompt to describe desired movement

### 🏗️ Architecture

**AWS Components:**
- **API Gateway**: REST endpoints for images and videos
- **Lambda Functions**: 
  - `NovaIntelligentImageGenerator`: Image generation with AI enhancement
  - `NovaWebSearchFunction`: Web search with Tavily/DuckDuckGo
  - `NovaVideoGenerator`: Start asynchronous video generation
  - `NovaVideoStatus`: Poll video generation status
- **S3 Bucket**: Video storage with 7-day lifecycle
- **Bedrock**: Access to Nova Canvas, Nova Lite, Nova Reel models
- **IAM Roles**: Permissions for Lambda and Bedrock

**AI Models Used:**
- `amazon.nova-canvas-v1:0`: Image generation
- `amazon.nova-lite-v1:0`: Prompt enhancement
- `amazon.nova-reel-v1:0`: Video generation


### 📦 Prerequisites

- Active AWS account
- Configured AWS CLI
- Access to Amazon Nova models in AWS Bedrock
- Supported region: `us-east-1` (recommended)
- (Optional) Tavily API Key for advanced web search

### 🔧 Installation

#### 1. Deploy CloudFormation Stack

```bash
# Clone the repository
git clone <repository-url>
cd nova-ai-generator

# Deploy with AWS CLI
aws cloudformation create-stack \
  --stack-name nova-ai-generator \
  --template-body file://nova-image-generator.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters ParameterKey=TavilyApiKey,ParameterValue=YOUR_API_KEY
```

**Or use the deployment script:**

```bash
chmod +x deploy-stack.sh
./deploy-stack.sh
```

#### 2. Get API Endpoints

After deployment, retrieve endpoints:

```bash
aws cloudformation describe-stacks \
  --stack-name nova-ai-generator \
  --query 'Stacks[0].Outputs'
```

Or from AWS CloudFormation console → Stack → "Outputs" tab

### ⚙️ Configuration

#### 1. Open Web Interface

Open the `Nova_Complete_v3_Images_And_Videos.html` file in your browser.

#### 2. Configure Endpoints

1. Go to **"⚙️ Endpoint"** tab
2. Paste the 3 endpoints from CloudFormation:
   - **Image Generation Endpoint** (from `ApiEndpoint`)
   - **Video Generation Endpoint** (from `VideoApiEndpoint`)
   - **Video Status Endpoint** (from `VideoStatusEndpoint`)
3. Click **"💾 Salva Configurazione"** (Save Configuration)

Endpoints are saved in browser (localStorage) and don't need to be re-entered.


### 🎯 Usage

#### Image Generation

**Text-to-Image:**
1. **"📸 Immagini"** (Images) tab
2. Select **"✨ Nuova Immagine"** (New Image)
3. Enter prompt (e.g., "A futuristic city at sunset")
4. (Optional) Enable web search for better results
5. Click **"🚀 Genera Immagine"** (Generate Image)
6. Wait ~10-15 seconds
7. Download with **"💾 Scarica"** (Download)

**Image-to-Image:**
1. **"📸 Immagini"** (Images) tab
2. Select **"🖼️ Modifica Immagine"** (Edit Image)
3. Upload image (click or drag & drop)
4. Enter modification prompt
5. Click **"🚀 Genera Immagine"** (Generate Image)

#### Video Generation

**Text-to-Video:**
1. **"🎬 Video"** tab
2. Select **"✨ Testo → Video"** (Text to Video)
3. Choose duration (6/12/18 seconds)
4. Enter prompt (e.g., "Ocean waves crashing on beach")
5. Click **"🎬 Genera Video"** (Generate Video)
6. Wait (~90s for 6 seconds, ~3min for 12s, ~4.5min for 18s)
7. Download with **"💾 Scarica Video"** (Download Video)

**Image-to-Video:**
1. **"🎬 Video"** tab
2. Select **"🖼️ Immagine → Video"** (Image to Video)
3. Upload image to animate
4. Choose duration
5. Enter motion prompt (e.g., "Camera slowly zooms in")
6. Click **"🎬 Genera Video"** (Generate Video)

### 💰 Costs

**Estimated AWS costs (us-east-1):**

- **Nova Canvas (Images)**:
  - Text-to-Image: ~$0.04 per image
  - Image-to-Image: ~$0.04 per image

- **Nova Reel (Videos)**:
  - 6 seconds: ~$0.30 per video
  - 12 seconds: ~$0.60 per video
  - 18 seconds: ~$0.90 per video

- **Lambda**: ~$0.0000002 per request (virtually free)
- **API Gateway**: ~$0.0000035 per request
- **S3**: ~$0.023 per GB/month (videos deleted after 7 days)

**Note**: Prices are indicative and may vary. Check [AWS Pricing](https://aws.amazon.com/pricing/) for updated details.


### 🔒 Security

- CORS configured for public access (`*`)
- No authentication required (modify for production)
- Video storage with automatic lifecycle (7 days)
- IAM roles with minimum necessary permissions

### 🛠️ Customization

#### Change Image Resolution

Currently only 1280x720 is supported by Nova Canvas. For other resolutions, modify the CloudFormation template (note: they may not work).

#### Add Authentication

For production, add:
- API Gateway Authorizer (Lambda/Cognito)
- Modify CORS for specific domains
- Rate limiting

#### Change Video Duration

Modify the HTML file, duration section:
```html
<option value="6">6 seconds</option>
<option value="12">12 seconds</option>
<option value="18">18 seconds</option>
```

### 📝 Limitations

- **Images**: Only 1280x720 resolution
- **Videos**: Only 1280x720 resolution, durations in 6-second multiples
- **Text in images**: Nova Canvas cannot generate readable text
- **Transparency**: Not supported in videos (automatically removed)
- **Video-to-Video**: Not supported by Nova Reel

### 🐛 Troubleshooting

**Error: "ValidationException: dimensions"**
- Image is automatically resized, check browser

**Error: "ValidationException: transparency"**
- Transparency is automatically removed, check browser

**Video not generating:**
- Verify endpoints in Endpoint tab
- Check CloudWatch Logs for Lambda errors
- Verify IAM permissions for Bedrock

**Web search not working:**
- Automatic fallback to DuckDuckGo if Tavily unavailable
- Check internet connection

### 📄 License

MIT License - See LICENSE file

### 🤝 Contributing

Contributions welcome! Open an issue or pull request.

---

**Made with ❤️ using Amazon Nova AI Models**
