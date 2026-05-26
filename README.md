# 🎨 Nova AI Generator - Generatore Completo di Immagini e Video

Soluzione completa per la generazione di contenuti multimediali AI utilizzando Stable Diffusion 3.5 Large (immagini) e Amazon Nova Reel 1.1 (video), con prompt enhancement tramite Amazon Nova 2 Lite.

Complete solution for AI media generation using Stable Diffusion 3.5 Large (images) and Amazon Nova Reel 1.1 (videos), with prompt enhancement via Amazon Nova 2 Lite.

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

#### Generazione Immagini (Stable Diffusion 3.5 Large)

**1. Text-to-Image (Testo → Immagine)**
- Genera immagini fotorealistiche da descrizioni testuali in qualsiasi lingua
- Traduzione automatica del prompt in inglese tramite Nova 2 Lite
- Ricerca web automatica per migliorare i risultati (opzionale)
- Prompt enhancement con AI per ottimizzare le descrizioni
- Risoluzioni multiple fino a 1 megapixel:
  - 1024×1024 (Quadrato 1:1)
  - 1280×720 (HD Landscape 16:9)
  - 1280×832 (Landscape 3:2)
  - 1152×896 (Landscape 4:3)
  - 720×1280 (HD Portrait 9:16)
  - 832×1280 (Portrait 2:3)
  - 896×1152 (Portrait 3:4)

**2. Image-to-Image (Modifica Immagine)**
- Modifica immagini esistenti con nuove descrizioni
- Upload tramite click o drag & drop
- Strength configurabile per il livello di modifica

#### Generazione Video (Nova Reel 1.1)

**1. Text-to-Video (Testo → Video)**
- Genera video cinematici da descrizioni testuali
- Durate disponibili: 6, 12, 18, 24, 30, 60, 90, 120 secondi (fino a 2 minuti)
- Risoluzione: 1280×720 @ 24fps
- Generazione asincrona con progress bar

**2. Image-to-Video (Immagine → Video)**
- Anima immagini statiche con movimento
- Upload con ridimensionamento automatico a 1280×720
- Rimozione trasparenza automatica
- Prompt per descrivere il movimento desiderato

### 🏗️ Architettura

**Componenti AWS:**
- **API Gateway**: Endpoint REST per immagini e video
- **Lambda Functions**: 
  - `NovaIntelligentImageGenerator`: Generazione immagini con AI enhancement e traduzione
  - `NovaWebSearchFunction`: Ricerca web con Tavily/DuckDuckGo
  - `NovaVideoGenerator`: Avvio generazione video asincrona
  - `NovaVideoStatus`: Polling stato generazione video
- **S3 Bucket**: Storage video con lifecycle 7 giorni
- **Bedrock**: Accesso ai modelli SD 3.5 Large, Nova 2 Lite, Nova Reel 1.1
- **IAM Roles**: Permessi per Lambda e Bedrock

**Modelli AI Utilizzati:**
- `stability.sd3-5-large-v1:0`: Generazione immagini (region: us-west-2)
- `us.amazon.nova-2-lite-v1:0`: Enhancement e traduzione prompt (inference profile)
- `amazon.nova-reel-v1:1`: Generazione video (fino a 2 minuti)

**Note Architetturali:**
- La Lambda è deployata in us-east-1 ma chiama SD 3.5 Large in us-west-2 (cross-region)
- Nova 2 Lite è chiamata tramite inference profile (prefisso `us.`)
- I prompt in qualsiasi lingua vengono tradotti automaticamente in inglese prima della generazione

### 📦 Prerequisiti

- Account AWS attivo
- AWS CLI configurato
- Accesso ai seguenti modelli in AWS Bedrock:
  - Stable Diffusion 3.5 Large (us-west-2)
  - Amazon Nova 2 Lite (us-east-1, inference profile)
  - Amazon Nova Reel 1.1 (us-east-1)
- Regione di deploy: `us-east-1`
- (Opzionale) Tavily API Key per ricerca web avanzata

### 🔧 Installazione

#### 1. Deploy CloudFormation Stack

```bash
# Clona il repository
git clone <repository-url>
cd nova-ai-generator

# Deploy con AWS CLI
aws cloudformation create-stack \
  --stack-name nova-image-generator \
  --template-body file://nova-image-generator.yaml \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=TavilyApiKey,ParameterValue=YOUR_API_KEY \
  --region us-east-1
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
  --stack-name nova-image-generator \
  --query 'Stacks[0].Outputs' \
  --region us-east-1
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
3. Scegli la risoluzione desiderata
4. Inserisci prompt in qualsiasi lingua (verrà tradotto automaticamente in inglese)
5. (Opzionale) Abilita ricerca web per risultati migliori
6. Clicca **"🚀 Genera Immagine"**
7. Attendi ~10-15 secondi
8. Scarica con **"💾 Scarica"**

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
3. Scegli durata (da 6 a 120 secondi)
4. Inserisci prompt (es. "Ocean waves crashing on beach")
5. Clicca **"🎬 Genera Video"**
6. Attendi (da ~90s per 6 secondi fino a ~17min per 2 minuti)
7. Scarica con **"💾 Scarica Video"**

**Image-to-Video:**
1. Tab **"🎬 Video"**
2. Seleziona **"🖼️ Immagine → Video"**
3. Carica immagine da animare
4. Scegli durata
5. Inserisci prompt movimento (es. "Camera slowly zooms in")
6. Clicca **"🎬 Genera Video"**

### 💰 Costi

**Costi AWS stimati (us-east-1 / us-west-2):**

- **Stable Diffusion 3.5 Large (Immagini)**:
  - Text-to-Image: ~$0.04 per immagine
  - Image-to-Image: ~$0.04 per immagine

- **Nova 2 Lite (Prompt Enhancement)**:
  - ~$0.0001 per richiesta (praticamente gratuito)

- **Nova Reel 1.1 (Video)**:
  - 6 secondi: ~$0.30 per video
  - 12 secondi: ~$0.60 per video
  - 30 secondi: ~$1.50 per video
  - 60 secondi: ~$3.00 per video
  - 120 secondi: ~$6.00 per video

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

#### Aggiungi Autenticazione

Per produzione, aggiungi:
- API Gateway Authorizer (Lambda/Cognito)
- Modifica CORS per domini specifici
- Rate limiting

#### Cambia Risoluzioni Immagini

Modifica il file HTML, sezione risoluzione. Le risoluzioni devono rispettare il limite di 1 megapixel (larghezza × altezza ≤ 1.048.576 pixel).

#### Cambia Durata Video

Modifica il file HTML, sezione durata. Le durate devono essere multipli di 6 secondi, fino a un massimo di 120 secondi.

### 📝 Limitazioni

- **Immagini**: Massimo 1 megapixel (es. 1024×1024, 1280×720)
- **Video**: Solo risoluzione 1280×720, durate multipli di 6 secondi (max 120s)
- **Testo nelle immagini**: SD 3.5 ha capacità limitate di generare testo leggibile
- **Trasparenza**: Non supportata nei video (rimossa automaticamente)
- **Video-to-Video**: Non supportato da Nova Reel
- **Prompt**: SD 3.5 funziona meglio con prompt in inglese (la traduzione automatica è inclusa)

### 🐛 Troubleshooting

**Errore: "No image generated"**
- Il content filter di SD 3.5 potrebbe bloccare il prompt. Prova a riformulare
- Verifica che Nova 2 Lite sia accessibile (necessario per tradurre il prompt)

**Errore: "Access denied / Legacy model"**
- Verifica l'accesso ai modelli nella console Bedrock
- SD 3.5 Large deve essere abilitato in us-west-2
- Nova 2 Lite deve essere accessibile tramite inference profile

**Video non si genera:**
- Verifica endpoint nella tab Endpoint
- Controlla CloudWatch Logs per errori Lambda
- Verifica permessi IAM per Bedrock
- Per video lunghi (>60s), il timeout potrebbe essere un problema

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

#### Image Generation (Stable Diffusion 3.5 Large)

**1. Text-to-Image**
- Generate photorealistic images from text descriptions in any language
- Automatic prompt translation to English via Nova 2 Lite
- Automatic web search to improve results (optional)
- AI-powered prompt enhancement
- Multiple resolutions up to 1 megapixel:
  - 1024×1024 (Square 1:1)
  - 1280×720 (HD Landscape 16:9)
  - 1280×832 (Landscape 3:2)
  - 1152×896 (Landscape 4:3)
  - 720×1280 (HD Portrait 9:16)
  - 832×1280 (Portrait 2:3)
  - 896×1152 (Portrait 3:4)

**2. Image-to-Image (Image Editing)**
- Modify existing images with new descriptions
- Upload via click or drag & drop
- Configurable strength for modification level

#### Video Generation (Nova Reel 1.1)

**1. Text-to-Video**
- Generate cinematic videos from text descriptions
- Available durations: 6, 12, 18, 24, 30, 60, 90, 120 seconds (up to 2 minutes)
- Resolution: 1280×720 @ 24fps
- Asynchronous generation with progress bar

**2. Image-to-Video**
- Animate static images with motion
- Upload with automatic resizing to 1280×720
- Automatic transparency removal
- Prompt to describe desired movement

### 🏗️ Architecture

**AWS Components:**
- **API Gateway**: REST endpoints for images and videos
- **Lambda Functions**: 
  - `NovaIntelligentImageGenerator`: Image generation with AI enhancement and translation
  - `NovaWebSearchFunction`: Web search with Tavily/DuckDuckGo
  - `NovaVideoGenerator`: Start asynchronous video generation
  - `NovaVideoStatus`: Poll video generation status
- **S3 Bucket**: Video storage with 7-day lifecycle
- **Bedrock**: Access to SD 3.5 Large, Nova 2 Lite, Nova Reel 1.1 models
- **IAM Roles**: Permissions for Lambda and Bedrock

**AI Models Used:**
- `stability.sd3-5-large-v1:0`: Image generation (region: us-west-2)
- `us.amazon.nova-2-lite-v1:0`: Prompt enhancement and translation (inference profile)
- `amazon.nova-reel-v1:1`: Video generation (up to 2 minutes)

**Architecture Notes:**
- Lambda is deployed in us-east-1 but calls SD 3.5 Large in us-west-2 (cross-region)
- Nova 2 Lite is called via inference profile (`us.` prefix)
- Prompts in any language are automatically translated to English before generation

### 📦 Prerequisites

- Active AWS account
- Configured AWS CLI
- Access to the following models in AWS Bedrock:
  - Stable Diffusion 3.5 Large (us-west-2)
  - Amazon Nova 2 Lite (us-east-1, inference profile)
  - Amazon Nova Reel 1.1 (us-east-1)
- Deploy region: `us-east-1`
- (Optional) Tavily API Key for advanced web search

### 🔧 Installation

#### 1. Deploy CloudFormation Stack

```bash
# Clone the repository
git clone <repository-url>
cd nova-ai-generator

# Deploy with AWS CLI
aws cloudformation create-stack \
  --stack-name nova-image-generator \
  --template-body file://nova-image-generator.yaml \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=TavilyApiKey,ParameterValue=YOUR_API_KEY \
  --region us-east-1
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
  --stack-name nova-image-generator \
  --query 'Stacks[0].Outputs' \
  --region us-east-1
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
3. Choose desired resolution
4. Enter prompt in any language (automatically translated to English)
5. (Optional) Enable web search for better results
6. Click **"🚀 Genera Immagine"** (Generate Image)
7. Wait ~10-15 seconds
8. Download with **"💾 Scarica"** (Download)

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
3. Choose duration (6 to 120 seconds)
4. Enter prompt (e.g., "Ocean waves crashing on beach")
5. Click **"🎬 Genera Video"** (Generate Video)
6. Wait (from ~90s for 6 seconds up to ~17min for 2 minutes)
7. Download with **"💾 Scarica Video"** (Download Video)

**Image-to-Video:**
1. **"🎬 Video"** tab
2. Select **"🖼️ Immagine → Video"** (Image to Video)
3. Upload image to animate
4. Choose duration
5. Enter motion prompt (e.g., "Camera slowly zooms in")
6. Click **"🎬 Genera Video"** (Generate Video)

### 💰 Costs

**Estimated AWS costs (us-east-1 / us-west-2):**

- **Stable Diffusion 3.5 Large (Images)**:
  - Text-to-Image: ~$0.04 per image
  - Image-to-Image: ~$0.04 per image

- **Nova 2 Lite (Prompt Enhancement)**:
  - ~$0.0001 per request (virtually free)

- **Nova Reel 1.1 (Videos)**:
  - 6 seconds: ~$0.30 per video
  - 12 seconds: ~$0.60 per video
  - 30 seconds: ~$1.50 per video
  - 60 seconds: ~$3.00 per video
  - 120 seconds: ~$6.00 per video

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

#### Add Authentication

For production, add:
- API Gateway Authorizer (Lambda/Cognito)
- Modify CORS for specific domains
- Rate limiting

#### Change Image Resolutions

Modify the HTML file, resolution section. Resolutions must respect the 1 megapixel limit (width × height ≤ 1,048,576 pixels).

#### Change Video Duration

Modify the HTML file, duration section. Durations must be multiples of 6 seconds, up to a maximum of 120 seconds.

### 📝 Limitations

- **Images**: Maximum 1 megapixel (e.g., 1024×1024, 1280×720)
- **Videos**: Only 1280×720 resolution, durations in 6-second multiples (max 120s)
- **Text in images**: SD 3.5 has limited ability to generate readable text
- **Transparency**: Not supported in videos (automatically removed)
- **Video-to-Video**: Not supported by Nova Reel
- **Prompts**: SD 3.5 works best with English prompts (automatic translation included)

### 🐛 Troubleshooting

**Error: "No image generated"**
- SD 3.5's content filter may block the prompt. Try rephrasing
- Verify Nova 2 Lite is accessible (needed for prompt translation)

**Error: "Access denied / Legacy model"**
- Check model access in Bedrock console
- SD 3.5 Large must be enabled in us-west-2
- Nova 2 Lite must be accessible via inference profile

**Video not generating:**
- Verify endpoints in Endpoint tab
- Check CloudWatch Logs for Lambda errors
- Verify IAM permissions for Bedrock
- For long videos (>60s), timeout may be an issue

**Web search not working:**
- Automatic fallback to DuckDuckGo if Tavily unavailable
- Check internet connection

### 📄 License

MIT License - See LICENSE file

### 🤝 Contributing

Contributions welcome! Open an issue or pull request.

---

**Made with ❤️ using Stable Diffusion 3.5 Large, Amazon Nova 2 Lite & Amazon Nova Reel 1.1**
