"""
generate_ppt_v3.py
Builds Bharat_AI_Bank_Presentation_v3.pptx by:
1. Using HomeEase.pptx as a complete template (master, theme, fonts)
2. Creating new slides with PROPER XML structure (using scheme colors, not hex)
3. Following HomeEase's simpler, cleaner layout approach
4. Team slides first, then project narrative
"""

import zipfile, re, os
from lxml import etree

SRC  = r"C:\Users\princy.shah\Desktop\Hackathon\HomeEase.pptx"
DEST = r"C:\Users\princy.shah\Documents\Agentforce_Hackathon\scripts\Bharat_AI_Bank_Presentation_v3.pptx"

# Slide dimensions (HomeEase standard)
W, H = 9144000, 5143500

def emu(inches):
    """Convert inches to EMU"""
    return int(inches * 914400)

# ──────────────────────────────────────────────────────────────────────────────
# XML Builder (using proper namespace-aware approach)
# ──────────────────────────────────────────────────────────────────────────────

NS = {
    'a': 'http://schemas.openxmlformats.org/drawingml/2006/main',
    'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
    'p': 'http://schemas.openxmlformats.org/presentationml/2006/main',
}

def make_slide_xml(title_text, body_lines, layout_type="title_body"):
    """
    Create a slide XML with proper namespace handling.
    layout_type: 'title', 'title_body', 'title_only'
    """
    # Create root element
    sld = etree.Element('{http://schemas.openxmlformats.org/presentationml/2006/main}sld')
    cSld = etree.SubElement(sld, '{http://schemas.openxmlformats.org/presentationml/2006/main}cSld')
    spTree = etree.SubElement(cSld, '{http://schemas.openxmlformats.org/presentationml/2006/main}spTree')

    # Group shape properties (required)
    nvGrpSpPr = etree.SubElement(spTree, '{http://schemas.openxmlformats.org/presentationml/2006/main}nvGrpSpPr')
    cNvPr = etree.SubElement(nvGrpSpPr, '{http://schemas.openxmlformats.org/presentationml/2006/main}cNvPr')
    cNvPr.set('id', '1')
    cNvPr.set('name', 'Slide')
    cNvGrpSpPr = etree.SubElement(nvGrpSpPr, '{http://schemas.openxmlformats.org/presentationml/2006/main}cNvGrpSpPr')
    nvPr = etree.SubElement(nvGrpSpPr, '{http://schemas.openxmlformats.org/presentationml/2006/main}nvPr')

    grpSpPr = etree.SubElement(spTree, '{http://schemas.openxmlformats.org/presentationml/2006/main}grpSpPr')
    xfrm = etree.SubElement(grpSpPr, '{http://schemas.openxmlformats.org/drawingml/2006/main}xfrm')
    off = etree.SubElement(xfrm, '{http://schemas.openxmlformats.org/drawingml/2006/main}off')
    off.set('x', '0')
    off.set('y', '0')
    ext = etree.SubElement(xfrm, '{http://schemas.openxmlformats.org/drawingml/2006/main}ext')
    ext.set('cx', '0')
    ext.set('cy', '0')
    chOff = etree.SubElement(xfrm, '{http://schemas.openxmlformats.org/drawingml/2006/main}chOff')
    chOff.set('x', '0')
    chOff.set('y', '0')
    chExt = etree.SubElement(xfrm, '{http://schemas.openxmlformats.org/drawingml/2006/main}chExt')
    chExt.set('cx', '0')
    chExt.set('cy', '0')

    # ────────────────────────────────────────────────────────────────────────
    # TITLE SHAPE
    sp_title = etree.SubElement(spTree, '{http://schemas.openxmlformats.org/presentationml/2006/main}sp')

    nvSpPr = etree.SubElement(sp_title, '{http://schemas.openxmlformats.org/presentationml/2006/main}nvSpPr')
    cNvPr_t = etree.SubElement(nvSpPr, '{http://schemas.openxmlformats.org/presentationml/2006/main}cNvPr')
    cNvPr_t.set('id', '2')
    cNvPr_t.set('name', 'Title')
    cNvSpPr_t = etree.SubElement(nvSpPr, '{http://schemas.openxmlformats.org/presentationml/2006/main}cNvSpPr')
    cNvSpPr_t.set('txBox', '1')
    nvPr_t = etree.SubElement(nvSpPr, '{http://schemas.openxmlformats.org/presentationml/2006/main}nvPr')

    spPr_t = etree.SubElement(sp_title, '{http://schemas.openxmlformats.org/presentationml/2006/main}spPr')
    xfrm_t = etree.SubElement(spPr_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}xfrm')
    off_t = etree.SubElement(xfrm_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}off')
    off_t.set('x', str(emu(0.5)))
    off_t.set('y', str(emu(0.3)))
    ext_t = etree.SubElement(xfrm_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}ext')
    ext_t.set('cx', str(emu(8.8)))
    ext_t.set('cy', str(emu(0.7)))

    prst = etree.SubElement(spPr_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}prstGeom')
    prst.set('prst', 'rect')
    avLst = etree.SubElement(prst, '{http://schemas.openxmlformats.org/drawingml/2006/main}avLst')

    noFill = etree.SubElement(spPr_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}noFill')
    ln = etree.SubElement(spPr_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}ln')
    ln_noFill = etree.SubElement(ln, '{http://schemas.openxmlformats.org/drawingml/2006/main}noFill')

    txBody_t = etree.SubElement(sp_title, '{http://schemas.openxmlformats.org/presentationml/2006/main}txBody')
    bodyPr_t = etree.SubElement(txBody_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}bodyPr')
    bodyPr_t.set('anchor', 'b')
    lstStyle_t = etree.SubElement(txBody_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}lstStyle')

    p_t = etree.SubElement(txBody_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}p')
    pPr_t = etree.SubElement(p_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}pPr')
    pPr_t.set('algn', 'l')

    r_t = etree.SubElement(p_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}r')
    rPr_t = etree.SubElement(r_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}rPr')
    rPr_t.set('lang', 'en')
    rPr_t.set('sz', '3200')
    rPr_t.set('b', '1')
    solidFill_t = etree.SubElement(rPr_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}solidFill')
    schemeClr_t = etree.SubElement(solidFill_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}schemeClr')
    schemeClr_t.set('val', 'lt1')
    latin_t = etree.SubElement(rPr_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}latin')
    latin_t.set('typeface', 'Roboto')

    t_t = etree.SubElement(r_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}t')
    t_t.text = title_text

    endParaRPr_t = etree.SubElement(p_t, '{http://schemas.openxmlformats.org/drawingml/2006/main}endParaRPr')

    # ────────────────────────────────────────────────────────────────────────
    # BODY SHAPE (if needed)
    if body_lines:
        sp_body = etree.SubElement(spTree, '{http://schemas.openxmlformats.org/presentationml/2006/main}sp')

        nvSpPr_b = etree.SubElement(sp_body, '{http://schemas.openxmlformats.org/presentationml/2006/main}nvSpPr')
        cNvPr_b = etree.SubElement(nvSpPr_b, '{http://schemas.openxmlformats.org/presentationml/2006/main}cNvPr')
        cNvPr_b.set('id', '3')
        cNvPr_b.set('name', 'Body')
        cNvSpPr_b = etree.SubElement(nvSpPr_b, '{http://schemas.openxmlformats.org/presentationml/2006/main}cNvSpPr')
        cNvSpPr_b.set('txBox', '1')
        nvPr_b = etree.SubElement(nvSpPr_b, '{http://schemas.openxmlformats.org/presentationml/2006/main}nvPr')

        spPr_b = etree.SubElement(sp_body, '{http://schemas.openxmlformats.org/presentationml/2006/main}spPr')
        xfrm_b = etree.SubElement(spPr_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}xfrm')
        off_b = etree.SubElement(xfrm_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}off')
        off_b.set('x', str(emu(0.5)))
        off_b.set('y', str(emu(1.2)))
        ext_b = etree.SubElement(xfrm_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}ext')
        ext_b.set('cx', str(emu(8.8)))
        ext_b.set('cy', str(emu(3.5)))

        prst_b = etree.SubElement(spPr_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}prstGeom')
        prst_b.set('prst', 'rect')
        avLst_b = etree.SubElement(prst_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}avLst')

        noFill_b = etree.SubElement(spPr_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}noFill')
        ln_b = etree.SubElement(spPr_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}ln')
        ln_noFill_b = etree.SubElement(ln_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}noFill')

        txBody_b = etree.SubElement(sp_body, '{http://schemas.openxmlformats.org/presentationml/2006/main}txBody')
        bodyPr_b = etree.SubElement(txBody_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}bodyPr')
        bodyPr_b.set('anchor', 't')
        lstStyle_b = etree.SubElement(txBody_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}lstStyle')

        for line in body_lines:
            p_b = etree.SubElement(txBody_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}p')
            pPr_b = etree.SubElement(p_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}pPr')
            pPr_b.set('algn', 'l')
            spcBef = etree.SubElement(pPr_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}spcBef')
            spcPts = etree.SubElement(spcBef, '{http://schemas.openxmlformats.org/drawingml/2006/main}spcPts')
            spcPts.set('val', '200')

            r_b = etree.SubElement(p_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}r')
            rPr_b = etree.SubElement(r_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}rPr')
            rPr_b.set('lang', 'en')
            rPr_b.set('sz', '2000')
            solidFill_b = etree.SubElement(rPr_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}solidFill')
            schemeClr_b = etree.SubElement(solidFill_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}schemeClr')
            schemeClr_b.set('val', 'lt1')
            latin_b = etree.SubElement(rPr_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}latin')
            latin_b.set('typeface', 'Roboto')

            t_b = etree.SubElement(r_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}t')
            t_b.text = line

            endParaRPr_b = etree.SubElement(p_b, '{http://schemas.openxmlformats.org/drawingml/2006/main}endParaRPr')

    # Color map override
    clrMapOvr = etree.SubElement(sld, '{http://schemas.openxmlformats.org/presentationml/2006/main}clrMapOvr')
    masterClrMapping = etree.SubElement(clrMapOvr, '{http://schemas.openxmlformats.org/drawingml/2006/main}masterClrMapping')

    return etree.tostring(sld, encoding='unicode', xml_declaration=True, standalone=True)

# ──────────────────────────────────────────────────────────────────────────────
# SLIDES DATA
# ──────────────────────────────────────────────────────────────────────────────

slides_data = [
    ("Bharat AI Bank", ["Intelligent Banking with Agentforce AI", "Team: AgentX Innovators | Accenture | 2025"]),
    ("Meet the Team", ["Princy Shah - Salesforce Tech Lead", "Shraddha Dere - Salesforce Tech Lead",
                       "Ankur Omar - Salesforce Manager", "Ravi Kamal - Salesforce Tech Lead"]),
    ("Mission Statement", ["Our mission is to transform the banking experience through a unified, AI-powered Agentforce platform that gives every customer a smart, personalised assistant — capable of checking balances, detecting fraud, processing KYC documents, resolving disputes, and delivering instant support in any language, 24 × 7."]),
    ("The Problem", [
        "• Fragmented banking channels — Customers navigate multiple apps, IVR, and branches",
        "• Slow, manual document processing — KYC & disputes take 5-10 business days",
        "• No intelligent personalisation — Chatbots fail in regional languages and context"
    ]),
    ("The Solution", [
        "• Agentforce-powered banking AI agent — Always-on, understands English & Hindi",
        "• AI document processing — Document AI instantly reads receipts, KYC, invoices",
        "• End-to-end automation — Dispute filing to KYC approval, all via Salesforce"
    ]),
    ("The Technology", [
        "Salesforce Agentforce (GenAI Planner)",
        "Salesforce Service Cloud (CRM, Cases, Omnichannel)",
        "Document AI / IDP (PDF extraction)",
        "Apex & Salesforce Flows (Transaction processing)",
        "Experience Cloud & LWC (Customer portal)"
    ]),
    ("How It Works", [
        "Step 1: Customer initiates via chat → Agentforce detects intent → Creates Case",
        "Step 2: GenAI Planner selects action (GetBalance, FileDispute, ProcessDocAI)",
        "Step 3: When customer uploads PDF → Document AI instantly extracts data",
        "Step 4: Agent responds in English or Hindi with live account data",
        "Step 5: Autonomously resolves disputes & KYC with zero manual intervention",
        "Step 6: Complex issues escalate to human agent via Omnichannel"
    ]),
    ("Business Benefits", [
        "✓ Reduce dispute resolution from 5-10 days to under 2 minutes",
        "✓ Eliminate 70% of call centre load with AI-driven automation",
        "✓ Personalised, multilingual (English + Hindi) 24×7 support",
        "✓ Unified banking ecosystem on single Salesforce platform"
    ]),
    ("Demo Story: Before", [
        "Traditional banking — Customer Rahul notices fraudulent Rs 4,500 debit",
        "Calls bank → waits 25 minutes → IVR cannot understand → transferred 3 times",
        "Asked to visit branch with physical documents → fills paper form",
        "Told resolution takes 7-10 days → no visibility → considers switching banks"
    ]),
    ("Demo Story: After", [
        "Bharat AI Bank — Rahul opens chat → 'I want to dispute a transaction'",
        "AI agent asks for receipt → uploads PDF → Document AI extracts Rs 4,500",
        "Dispute filed in Salesforce in 90 seconds → Agent responds in Hindi when requested",
        "Full audit trail, zero manual effort, instant status updates via chat"
    ]),
    ("Demo Outcome", [
        "✓ Dispute resolved in under 2 minutes (vs 7-10 days traditional)",
        "✓ Zero branch visit required",
        "✓ AI agent handled entirely in Hindi",
        "✓ KYC verified & approved in same session",
        "✓ Customer satisfaction: instant, transparent, effortless"
    ]),
    ("Thank You", [
        "Team: AgentX Innovators | Accenture | 2025",
        "Princy Shah • Shraddha Dere • Ankur Omar • Ravi Kamal",
        "GitHub: github.com/princy2806/Bharat-AI-Bank"
    ]),
]

# ──────────────────────────────────────────────────────────────────────────────
# Generate PPTX
# ──────────────────────────────────────────────────────────────────────────────

# Copy base from HomeEase, remove old slides, insert new ones
import shutil
shutil.copy(SRC, DEST)

with zipfile.ZipFile(DEST, 'r') as z:
    src_pres = z.read('ppt/presentation.xml').decode('utf-8')
    src_pres_rels = z.read('ppt/_rels/presentation.xml.rels').decode('utf-8')
    src_ct = z.read('[Content_Types].xml').decode('utf-8')

# Clean old slides from XML
src_pres_clean = re.sub(r'<p:sldIdLst>.*?</p:sldIdLst>', '<p:sldIdLst></p:sldIdLst>', src_pres, flags=re.DOTALL)
src_pres_rels_clean = re.sub(r'<Relationship Id="rId\d+" Type=".*?slides/slide\d+\.xml"[^/]*/>', '', src_pres_rels)
src_ct_clean = re.sub(r'<Override PartName="/ppt/slides/slide\d+\.xml"[^/]*/>|<Override PartName="/ppt/notesSlides/notesSlide\d+\.xml"[^/]*/>', '', src_ct)

# Build new slide list
N = len(slides_data)
new_sldid_list = ''.join(f'<p:sldId id="{256+i}" r:id="rId{8+i}"/>' for i in range(N))
new_pres = src_pres_clean.replace('<p:sldIdLst></p:sldIdLst>', f'<p:sldIdLst>{new_sldid_list}</p:sldIdLst>')

new_rels = ''.join(
    f'<Relationship Id="rId{8+i}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide{i+1}.xml"/>'
    for i in range(N)
)
new_pres_rels = src_pres_rels_clean.replace('</Relationships>', new_rels + '</Relationships>')

new_overrides = ''.join(
    f'<Override PartName="/ppt/slides/slide{i+1}.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>'
    for i in range(N)
)
new_ct = src_ct_clean.replace('</Types>', new_overrides + '</Types>')

# Write updated PPTX
with zipfile.ZipFile(DEST, 'a') as z:
    # Remove old slides
    for name in z.namelist():
        if name.startswith('ppt/slides/slide') and name.endswith('.xml') and not name.startswith('ppt/slideLayouts/') and not name.startswith('ppt/slideMasters/'):
            z.close()
            break

# Rebuild completely
with zipfile.ZipFile(DEST, 'r') as src_z:
    with zipfile.ZipFile(DEST + '.tmp', 'w', zipfile.ZIP_DEFLATED) as out_z:
        for name in src_z.namelist():
            if name.startswith('ppt/slides/slide') and name.endswith('.xml') and '/slides/' in name:
                continue  # Skip old slides
            if name == 'ppt/presentation.xml' or name == 'ppt/_rels/presentation.xml.rels' or name == '[Content_Types].xml':
                continue  # Skip, we'll rewrite
            out_z.writestr(name, src_z.read(name))

        # Write new versions
        out_z.writestr('ppt/presentation.xml', new_pres.encode('utf-8'))
        out_z.writestr('ppt/_rels/presentation.xml.rels', new_pres_rels.encode('utf-8'))
        out_z.writestr('[Content_Types].xml', new_ct.encode('utf-8'))

        # Write new slides
        for i, (title, body_lines) in enumerate(slides_data):
            slide_xml = make_slide_xml(title, body_lines)
            out_z.writestr(f'ppt/slides/slide{i+1}.xml', slide_xml.encode('utf-8'))

            # Write slide rels
            slide_rels = f'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout7.xml"/></Relationships>'''
            out_z.writestr(f'ppt/slides/_rels/slide{i+1}.xml.rels', slide_rels.encode('utf-8'))

os.remove(DEST)
os.rename(DEST + '.tmp', DEST)

print(f"✅ PPT created: {DEST}")
print(f"   Slides: {N}")
size_kb = os.path.getsize(DEST) // 1024
print(f"   Size: {size_kb} KB")
print()
print("Slides:")
for i, (title, _) in enumerate(slides_data, 1):
    print(f"  {i:2}. {title}")
