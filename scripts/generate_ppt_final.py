"""
generate_ppt_final.py
Creates Bharat_AI_Bank_Presentation.pptx using:
- Navy Blue (#1A3A52) background
- Gold (#E8B923) accents & titles
- White text
- Teal (#4A90E2) highlights
"""

import zipfile, shutil, re, os

SRC  = r"C:\Users\princy.shah\Desktop\Hackathon\HomeEase.pptx"
DEST = r"C:\Users\princy.shah\Documents\Agentforce_Hackathon\scripts\Bharat_AI_Bank_Presentation.pptx"

W, H = 9144000, 5143500
def emu(inches): return int(inches * 914400)

# Custom colors (from your Bharat AI Bank website)
NAVY    = "1A3A52"  # Dark navy blue background
GOLD    = "E8B923"  # Gold accents
WHITE   = "FFFFFF"  # White text
TEAL    = "4A90E2"  # Teal highlights
PURPLE  = "6B4FA1"  # Account card color
GREEN   = "2E8B57"  # Account card color
GRAY    = "4A5568"  # Secondary text

def make_slide(title, bullets, bg_color=NAVY, title_color=GOLD, text_color=WHITE):
    """Create a simple, clean slide with title + bullets"""

    shapes_xml = ""
    sid = 2

    # TITLE BOX
    shapes_xml += f'''
<p:sp>
  <p:nvSpPr>
    <p:cNvPr id="{sid}" name="Title"/>
    <p:cNvSpPr txBox="1"/><p:nvPr/>
  </p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(0.4)}" y="{emu(0.3)}"/><a:ext cx="{emu(8.9)}" cy="{emu(0.75)}"/></a:xfrm>
    <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
    <a:noFill/><a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody>
    <a:bodyPr/><a:lstStyle/>
    <a:p>
      <a:pPr algn="l"/>
      <a:r>
        <a:rPr lang="en" sz="3600" b="1">
          <a:solidFill><a:srgbClr val="{title_color}"/></a:solidFill>
          <a:latin typeface="Roboto"/>
        </a:rPr>
        <a:t>{title}</a:t>
      </a:r>
    </a:p>
  </p:txBody>
</p:sp>
'''
    sid += 1

    # SEPARATOR LINE
    shapes_xml += f'''
<p:sp>
  <p:nvSpPr>
    <p:cNvPr id="{sid}" name="Line"/>
    <p:cNvSpPr/><p:nvPr/>
  </p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(0.4)}" y="{emu(1.15)}"/><a:ext cx="{emu(2.5)}" cy="{emu(0.04)}"/></a:xfrm>
    <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
    <a:solidFill><a:srgbClr val="{title_color}"/></a:solidFill>
    <a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody><a:bodyPr/><a:lstStyle/></p:txBody>
</p:sp>
'''
    sid += 1

    # BULLET POINTS
    if bullets:
        shapes_xml += f'''
<p:sp>
  <p:nvSpPr>
    <p:cNvPr id="{sid}" name="Body"/>
    <p:cNvSpPr txBox="1"/><p:nvPr/>
  </p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(0.4)}" y="{emu(1.3)}"/><a:ext cx="{emu(8.9)}" cy="{emu(3.5)}"/></a:xfrm>
    <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
    <a:noFill/><a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody>
    <a:bodyPr/><a:lstStyle/>
'''
        for bullet in bullets:
            shapes_xml += f'''
    <a:p>
      <a:pPr algn="l" marL="{emu(0.2)}" indent="{-emu(0.2)}">
        <a:spcBef><a:spcPts val="300"/></a:spcBef>
        <a:buFont typeface="Roboto"/>
        <a:buChar char="•"/>
      </a:pPr>
      <a:r>
        <a:rPr lang="en" sz="2000">
          <a:solidFill><a:srgbClr val="{text_color}"/></a:solidFill>
          <a:latin typeface="Roboto"/>
        </a:rPr>
        <a:t>{bullet}</a:t>
      </a:r>
    </a:p>
'''
        shapes_xml += '''
  </p:txBody>
</p:sp>
'''
        sid += 1

    return shapes_xml, sid

# ────────────────────────────────────────────────────────────────────────────
# BUILD ALL SLIDES
# ────────────────────────────────────────────────────────────────────────────

slides = [
    # Slide 1: Cover
    (f"""<p:sp>
  <p:nvSpPr><p:cNvPr id="2" name="Title"/><p:cNvSpPr txBox="1"/><p:nvPr/></p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(0.5)}" y="{emu(1.5)}"/><a:ext cx="{emu(8.8)}" cy="{emu(1.2)}"/></a:xfrm>
    <a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody><a:bodyPr/><a:lstStyle/>
    <a:p><a:pPr algn="ctr"/><a:r><a:rPr lang="en" sz="5400" b="1"><a:solidFill><a:srgbClr val="{GOLD}"/></a:solidFill><a:latin typeface="Roboto"/></a:rPr><a:t>Bharat AI Bank</a:t></a:r></a:p>
  </p:txBody>
</p:sp>
<p:sp>
  <p:nvSpPr><p:cNvPr id="3" name="Subtitle"/><p:cNvSpPr txBox="1"/><p:nvPr/></p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(0.5)}" y="{emu(2.9)}" /><a:ext cx="{emu(8.8)}" cy="{emu(0.8)}"/></a:xfrm>
    <a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody><a:bodyPr/><a:lstStyle/>
    <a:p><a:pPr algn="ctr"/><a:r><a:rPr lang="en" sz="2400"><a:solidFill><a:srgbClr val="{WHITE}"/></a:solidFill><a:latin typeface="Roboto"/></a:rPr><a:t>Intelligent Banking with Agentforce AI</a:t></a:r></a:p>
    <a:p><a:pPr algn="ctr"/><a:r><a:rPr lang="en" sz="1800"><a:solidFill><a:srgbClr val="{TEAL}"/></a:solidFill><a:latin typeface="Roboto"/></a:rPr><a:t>Team: AgentX Innovators | Accenture | 2025</a:t></a:r></a:p>
  </p:txBody>
</p:sp>""", 3),

    # Slide 2: Team Overview
    (make_slide("Meet the Team", [
        "Princy Shah - Salesforce Tech Lead, Accenture",
        "Shraddha Dere - Salesforce Tech Lead, Accenture",
        "Ankur Omar - Salesforce Manager, Accenture",
        "Ravi Kamal - Salesforce Tech Lead, Accenture"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 3: Mission
    (make_slide("Mission Statement", [
        "Transform banking through AI-powered Agentforce platform that gives every customer a smart, personalised assistant",
        "Capable of checking balances, detecting fraud, processing KYC documents, resolving disputes",
        "Instant support in any language, 24 × 7, without human intervention"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 4: Problem
    (make_slide("The Problem", [
        "Fragmented banking channels — customers navigate multiple apps, IVR, and branches",
        "Slow, manual document processing — KYC & disputes take 5-10 business days",
        "No intelligent personalisation — chatbots fail in regional languages and context"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 5: Solution
    (make_slide("The Solution", [
        "Agentforce-powered banking AI agent — always-on, understands English & Hindi",
        "AI document processing — Document AI instantly reads receipts, KYC, invoices",
        "End-to-end automation — dispute filing to KYC approval, all via Salesforce"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 6: Technology
    (make_slide("The Technology", [
        "Salesforce Agentforce (GenAI Planner with ReAct reasoning)",
        "Salesforce Service Cloud (CRM, Cases, Omnichannel routing)",
        "Document AI / IDP (PDF extraction, structured data)",
        "Apex & Salesforce Flows (Transaction processing, automation)",
        "Experience Cloud & LWC (Customer portal, chat interface)"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 7: How It Works
    (make_slide("How It Works", [
        "Step 1 — Customer initiates via chat, Agentforce detects intent, creates Case",
        "Step 2 — GenAI Planner selects action (GetBalance, FileDispute, ProcessDocAI)",
        "Step 3 — When customer uploads PDF, Document AI instantly extracts data",
        "Step 4 — Agent responds in English or Hindi with live account data",
        "Step 5 — Autonomously resolves disputes & KYC with zero manual effort",
        "Step 6 — Complex issues escalate to human agent via Omnichannel"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 8: Business Benefits
    (make_slide("Business Benefits", [
        "Reduce dispute resolution from 5-10 days to under 2 minutes",
        "Eliminate 70% of call centre load with AI-driven automation",
        "Personalised, multilingual (English + Hindi) 24×7 support",
        "Unified banking ecosystem on single Salesforce platform"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 9: Demo - Before
    (make_slide("Demo Story: Before", [
        "Customer Rahul notices fraudulent Rs 4,500 debit on credit card",
        "Calls bank → waits 25 minutes → IVR cannot understand → transferred 3 times",
        "Asked to visit branch with physical documents → fills paper form",
        "Told resolution takes 7-10 days → no visibility → considers switching banks"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 10: Demo - After
    (make_slide("Demo Story: After", [
        "Rahul opens Bharat AI Bank chat → 'I want to dispute a transaction'",
        "AI agent asks for receipt → uploads PDF → Document AI extracts Rs 4,500",
        "Dispute filed in Salesforce in 90 seconds",
        "Agent responds in Hindi when requested, full audit trail, zero manual effort"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 11: Outcome
    (make_slide("Demo Outcome", [
        "Dispute resolved in under 2 minutes (vs 7-10 days traditional)",
        "Zero branch visit required",
        "AI agent handled entirely in Hindi",
        "KYC verified & approved in same session",
        "Customer satisfaction: instant, transparent, effortless"
    ], NAVY, GOLD, WHITE)[0], make_slide("", [], NAVY, GOLD, WHITE)[1]),

    # Slide 12: Thank You
    (f"""<p:sp>
  <p:nvSpPr><p:cNvPr id="2" name="Title"/><p:cNvSpPr txBox="1"/><p:nvPr/></p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(0.5)}" y="{emu(1.5)}"/><a:ext cx="{emu(8.8)}" cy="{emu(0.9)}"/></a:xfrm>
    <a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody><a:bodyPr/><a:lstStyle/>
    <a:p><a:pPr algn="ctr"/><a:r><a:rPr lang="en" sz="4800" b="1"><a:solidFill><a:srgbClr val="{GOLD}"/></a:solidFill><a:latin typeface="Roboto"/></a:rPr><a:t>Thank You!</a:t></a:r></a:p>
  </p:txBody>
</p:sp>
<p:sp>
  <p:nvSpPr><p:cNvPr id="3" name="Content"/><p:cNvSpPr txBox="1"/><p:nvPr/></p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(0.5)}" y="{emu(2.8)}"/><a:ext cx="{emu(8.8)}" cy="{emu(1.8)}"/></a:xfrm>
    <a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody><a:bodyPr/><a:lstStyle/>
    <a:p><a:pPr algn="ctr"/><a:r><a:rPr lang="en" sz="2200"><a:solidFill><a:srgbClr val="{WHITE}"/></a:solidFill><a:latin typeface="Roboto"/></a:rPr><a:t>Team AgentX Innovators | Accenture | 2025</a:t></a:r></a:p>
    <a:p><a:pPr algn="ctr"/><a:r><a:rPr lang="en" sz="1900"><a:solidFill><a:srgbClr val="{TEAL}"/></a:solidFill><a:latin typeface="Roboto"/></a:rPr><a:t>Princy Shah • Shraddha Dere • Ankur Omar • Ravi Kamal</a:t></a:r></a:p>
    <a:p><a:pPr algn="ctr"/><a:r><a:rPr lang="en" sz="1700"><a:solidFill><a:srgbClr val="{WHITE}"/></a:solidFill><a:latin typeface="Roboto"/></a:rPr><a:t>GitHub: github.com/princy2806/Bharat-AI-Bank</a:t></a:r></a:p>
  </p:txBody>
</p:sp>""", 3),
]

# ────────────────────────────────────────────────────────────────────────────
# ASSEMBLE PPTX
# ────────────────────────────────────────────────────────────────────────────

N = len(slides)

# Copy template
shutil.copy(SRC, DEST)

# Read and update presentation files
with zipfile.ZipFile(DEST, 'r') as z:
    pres_xml = z.read('ppt/presentation.xml').decode('utf-8')
    pres_rels = z.read('ppt/_rels/presentation.xml.rels').decode('utf-8')
    ct_xml = z.read('[Content_Types].xml').decode('utf-8')

# Clean old slides
pres_xml_new = re.sub(r'<p:sldIdLst>.*?</p:sldIdLst>', '<p:sldIdLst></p:sldIdLst>', pres_xml, flags=re.DOTALL)
pres_rels_new = re.sub(r'<Relationship Id="rId\d+" Type=".*?slides/slide\d+\.xml"[^/]*/>', '', pres_rels)
ct_xml_new = re.sub(r'<Override PartName="/ppt/slides/slide\d+\.xml"[^/]*/>|<Override PartName="/ppt/notesSlides/notesSlide\d+\.xml"[^/]*/>', '', ct_xml)

# Build new lists
sldid_list = ''.join(f'<p:sldId id="{256+i}" r:id="rId{8+i}"/>' for i in range(N))
pres_xml_new = pres_xml_new.replace('<p:sldIdLst></p:sldIdLst>', f'<p:sldIdLst>{sldid_list}</p:sldIdLst>')

rels_list = ''.join(
    f'<Relationship Id="rId{8+i}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide{i+1}.xml"/>'
    for i in range(N)
)
pres_rels_new = pres_rels_new.replace('</Relationships>', rels_list + '</Relationships>')

overrides = ''.join(
    f'<Override PartName="/ppt/slides/slide{i+1}.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>'
    for i in range(N)
)
ct_xml_new = ct_xml_new.replace('</Types>', overrides + '</Types>')

# Rebuild PPTX
with zipfile.ZipFile(DEST, 'r') as src_z:
    with zipfile.ZipFile(DEST + '.tmp', 'w', zipfile.ZIP_DEFLATED) as out_z:
        for name in src_z.namelist():
            # Skip old slides
            if '/slides/slide' in name and name.endswith('.xml'):
                continue
            # Skip files we're replacing
            if name in ('ppt/presentation.xml', 'ppt/_rels/presentation.xml.rels', '[Content_Types].xml'):
                continue
            out_z.writestr(name, src_z.read(name))

        # Write new files
        out_z.writestr('ppt/presentation.xml', pres_xml_new.encode('utf-8'))
        out_z.writestr('ppt/_rels/presentation.xml.rels', pres_rels_new.encode('utf-8'))
        out_z.writestr('[Content_Types].xml', ct_xml_new.encode('utf-8'))

        # Write new slides
        for i, (shapes, _) in enumerate(slides):
            slide_xml = f'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:bg><p:bgPr><a:solidFill><a:srgbClr val="{NAVY}"/></a:solidFill><a:effectLst/></p:bgPr></p:bg>
    <p:spTree>
      <p:nvGrpSpPr><p:cNvPr id="1" name="Slide{i+1}"/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
      <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
      {shapes.strip()}
    </p:spTree>
  </p:cSld>
  <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
</p:sld>'''
            out_z.writestr(f'ppt/slides/slide{i+1}.xml', slide_xml.encode('utf-8'))

            # Write slide rels
            rels_xml = f'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
</Relationships>'''
            out_z.writestr(f'ppt/slides/_rels/slide{i+1}.xml.rels', rels_xml.encode('utf-8'))

os.remove(DEST)
os.rename(DEST + '.tmp', DEST)

print(f"✅ PPT created: {DEST}")
print(f"   Slides: {N}")
print(f"   Colors: Navy (#1A3A52) + Gold (#E8B923) + Teal (#4A90E2)")
size_kb = os.path.getsize(DEST) // 1024
print(f"   Size: {size_kb} KB")
