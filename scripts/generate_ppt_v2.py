"""
generate_ppt_v2.py
Builds Bharat_AI_Bank_Presentation_v2.pptx by cloning the HomeEase template
(master, themes, fonts, layouts) and injecting all new slides following
HomeEase's content narrative approach.
"""

import zipfile, shutil, re, os
from copy import deepcopy

SRC  = r"C:\Users\princy.shah\Desktop\Hackathon\HomeEase.pptx"
DEST = r"C:\Users\princy.shah\Documents\Agentforce_Hackathon\scripts\Bharat_AI_Bank_Presentation_v2.pptx"

# ──────────────────────────────────────────────────────────────────────────────
# EMU helpers (1 inch = 914400 EMU, slide = 9144000 x 5143500)
W, H = 9144000, 5143500

# XML namespaces
NS = 'xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" ' \
     'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" ' \
     'xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" ' \
     'xmlns:mv="urn:schemas-microsoft-com:mac:vml" ' \
     'xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" ' \
     'xmlns:c="http://schemas.openxmlformats.org/drawingml/2006/chart" ' \
     'xmlns:dgm="http://schemas.openxmlformats.org/drawingml/2006/diagram" ' \
     'xmlns:o="urn:schemas-microsoft-com:office:office" ' \
     'xmlns:v="urn:schemas-microsoft-com:vml" ' \
     'xmlns:pvml="urn:schemas-microsoft-com:office:powerpoint" ' \
     'xmlns:com="http://schemas.openxmlformats.org/drawingml/2006/compatibility" ' \
     'xmlns:p14="http://schemas.microsoft.com/office/powerpoint/2010/main" ' \
     'xmlns:p15="http://schemas.microsoft.com/office/powerpoint/2012/main" ' \
     'xmlns:ahyp="http://schemas.microsoft.com/office/drawing/2018/hyperlinkcolor"'

def emu(inches): return int(inches * 914400)

# ──────────────────────────────────────────────────────────────────────────────
# Low-level XML builders

def rpr(sz=2000, bold=False, color=None, font="Roboto"):
    b = ' b="1"' if bold else ''
    clr = f'<a:solidFill><a:srgbClr val="{color}"/></a:solidFill>' if color else \
          '<a:solidFill><a:schemeClr val="lt1"/></a:solidFill>'
    return (f'<a:rPr lang="en" sz="{sz}"{b}>'
            f'{clr}'
            f'<a:latin typeface="{font}"/>'
            f'<a:ea typeface="{font}"/>'
            f'</a:rPr>')

def run(text, sz=2000, bold=False, color=None):
    """Single text run"""
    if not text:
        return f'<a:r>{rpr(sz,bold,color)}<a:t></a:t></a:r>'
    return f'<a:r>{rpr(sz,bold,color)}<a:t>{text}</a:t></a:r>'

def para(text, sz=2000, bold=False, color=None, align="l", space_before=0, runs=None):
    """Single paragraph, optionally multi-run"""
    spc = f'<a:spcBef><a:spcPts val="{space_before}"/></a:spcBef>' if space_before else \
          '<a:spcBef><a:spcPts val="0"/></a:spcBef>'
    ppr = (f'<a:pPr indent="0" lvl="0" marL="0" rtl="0" algn="{align}">'
           f'{spc}<a:spcAft><a:spcPts val="0"/></a:spcAft><a:buNone/></a:pPr>')
    body = ''.join(runs) if runs else run(text, sz, bold, color)
    return f'<a:p>{ppr}{body}<a:endParaRPr/></a:p>'

def empty_para():
    return '<a:p><a:pPr><a:spcBef><a:spcPts val="0"/></a:spcBef><a:spcAft><a:spcPts val="0"/></a:spcAft><a:buNone/></a:pPr><a:r><a:t></a:t></a:r></a:p>'

def txbody(paragraphs_xml, anchor="ctr"):
    return (f'<p:txBody>'
            f'<a:bodyPr anchorCtr="0" anchor="{anchor}" bIns="91425" lIns="91425" '
            f'spcFirstLastPara="1" rIns="91425" wrap="square" tIns="91425"><a:noAutofit/></a:bodyPr>'
            f'<a:lstStyle/>'
            f'{paragraphs_xml}'
            f'</p:txBody>')

def shape(sid, x, y, w, h, tx_body, fill_color=None, no_fill=True):
    """Free-form text box shape"""
    fill = '<a:noFill/>' if no_fill else f'<a:solidFill><a:srgbClr val="{fill_color}"/></a:solidFill>'
    return (f'<p:sp>'
            f'<p:nvSpPr><p:cNvPr id="{sid}" name="Shape{sid}"/>'
            f'<p:cNvSpPr txBox="1"/><p:nvPr/></p:nvSpPr>'
            f'<p:spPr>'
            f'<a:xfrm><a:off x="{x}" y="{y}"/><a:ext cx="{w}" cy="{h}"/></a:xfrm>'
            f'<a:prstGeom prst="rect"><a:avLst/></a:prstGeom>'
            f'{fill}'
            f'<a:ln><a:noFill/></a:ln>'
            f'</p:spPr>'
            f'{tx_body}'
            f'</p:sp>')

def rect_shape(sid, x, y, w, h, fill_color):
    """Filled rectangle (no text)"""
    return (f'<p:sp>'
            f'<p:nvSpPr><p:cNvPr id="{sid}" name="Rect{sid}"/>'
            f'<p:cNvSpPr/><p:nvPr/></p:nvSpPr>'
            f'<p:spPr>'
            f'<a:xfrm><a:off x="{x}" y="{y}"/><a:ext cx="{w}" cy="{h}"/></a:xfrm>'
            f'<a:prstGeom prst="rect"><a:avLst/></a:prstGeom>'
            f'<a:solidFill><a:srgbClr val="{fill_color}"/></a:solidFill>'
            f'<a:ln><a:noFill/></a:ln>'
            f'</p:spPr>'
            f'<p:txBody><a:bodyPr/><a:lstStyle/><a:p/></p:txBody>'
            f'</p:sp>')

def wrap_slide(shapes_xml, layout_num=3):
    return (f'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            f'<p:sld {NS}>'
            f'<p:cSld><p:spTree>'
            f'<p:nvGrpSpPr><p:cNvPr id="1" name="Shape1"/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>'
            f'<p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>'
            f'<a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>'
            f'{shapes_xml}'
            f'</p:spTree></p:cSld>'
            f'<p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>'
            f'</p:sld>')

def slide_rels(layout_num=3):
    return (f'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            f'<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            f'<Relationship Id="rId1" '
            f'Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" '
            f'Target="../slideLayouts/slideLayout{layout_num}.xml"/>'
            f'</Relationships>')

# ──────────────────────────────────────────────────────────────────────────────
# Accent bar (bottom thin colored strip like HomeEase accent)
def accent_bar(color="0F9D58"):
    return rect_shape(900, 0, H - emu(0.08), W, emu(0.08), color)

# ──────────────────────────────────────────────────────────────────────────────
# SLIDE BUILDERS

# Colors
BLUE     = "4285F4"  # Google Blue (same as HomeEase background – but we use for accents)
DARK_BG  = "1A237E"  # Deep Navy (alternate dark)
WHITE    = "FFFFFF"
YELLOW   = "F4B400"  # HomeEase yellow
GREEN    = "0F9D58"  # HomeEase green
RED      = "DB4437"  # HomeEase red
LIGHT_BG = "1565C0"  # Mid blue box
ACCENT   = "4FC3F7"  # Light blue
CARD_BG  = "1976D2"  # Card background (lighter blue for cards)


def make_cover():
    """Slide 1 – Cover (like HomeEase slide 1: big title, subtitle, no clutter)"""
    shapes = ""
    # Thin top accent bar
    shapes += rect_shape(10, 0, 0, W, emu(0.12), YELLOW)
    # Main title
    shapes += shape(11, emu(0.5), emu(1.5), emu(9.1), emu(1.2),
        txbody(para("Bharat AI Bank", sz=5400, bold=True), "ctr"))
    # Subtitle
    shapes += shape(12, emu(0.5), emu(2.85), emu(9.1), emu(0.7),
        txbody(para("Intelligent Banking with Agentforce AI", sz=2800), "ctr"))
    # Separator line
    shapes += rect_shape(13, emu(4.0), emu(3.7), emu(2.15), emu(0.04), YELLOW)
    # Tagline
    shapes += shape(14, emu(0.5), emu(3.9), emu(9.1), emu(0.5),
        txbody(para("Team: AgentX Innovators  |  Accenture  |  2025", sz=1800, color="B0BEC5"), "ctr"))
    # Hackathon badge bottom right
    shapes += shape(15, emu(6.5), emu(4.5), emu(3.0), emu(0.5),
        txbody(para("Salesforce Agentforce Hackathon 2025", sz=1400, color=YELLOW), "r"))
    shapes += accent_bar(YELLOW)
    return wrap_slide(shapes, layout_num=1)


def make_team_overview():
    """Slide 2 – Team Overview (4 members as cards)"""
    members = [
        ("Princy Shah",    "Salesforce Tech Lead",   "Accenture"),
        ("Shraddha Dere",  "Salesforce Tech Lead",   "Accenture"),
        ("Ankur Omar",     "Salesforce Manager",     "Accenture"),
        ("Ravi Kamal",     "Salesforce Tech Lead",   "Accenture"),
    ]
    shapes = ""
    # Slide title
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.6),
        txbody(para("Meet the Team", sz=3200, bold=True), "b"))
    # Thin separator
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), YELLOW)
    # 4 member cards
    card_w = emu(2.05)
    card_h = emu(2.8)
    card_y = emu(1.35)
    colors = [GREEN, BLUE, RED, YELLOW]
    for i, (name, title, company) in enumerate(members):
        cx = emu(0.35) + i * emu(2.2)
        # Card background
        shapes += rect_shape(20+i, cx, card_y, card_w, card_h, CARD_BG)
        # Top color bar on card
        shapes += rect_shape(30+i, cx, card_y, card_w, emu(0.08), colors[i])
        # Name
        shapes += shape(40+i, cx + emu(0.12), card_y + emu(0.15), card_w - emu(0.2), emu(0.55),
            txbody(para(name, sz=1800, bold=True), "t"))
        # Title
        shapes += shape(50+i, cx + emu(0.12), card_y + emu(0.75), card_w - emu(0.2), emu(0.45),
            txbody(para(title, sz=1500, color=ACCENT), "t"))
        # Company
        shapes += shape(60+i, cx + emu(0.12), card_y + emu(1.25), card_w - emu(0.2), emu(0.4),
            txbody(para(company, sz=1400), "t"))
    # Team tagline
    shapes += shape(70, emu(0.5), emu(4.45), emu(9.1), emu(0.45),
        txbody(para("All team members are from Accenture, India", sz=1600, color="B0BEC5"), "ctr"))
    shapes += accent_bar(YELLOW)
    return wrap_slide(shapes, 3)


def make_member(sid_base, name, role, company, skills_lines, contrib_lines):
    """Individual team member slide (like HomeEase MAIN_POINT but split layout)"""
    shapes = ""
    # Left accent block
    shapes += rect_shape(sid_base, 0, 0, emu(0.25), H, YELLOW)
    # Name – large
    shapes += shape(sid_base+1, emu(0.45), emu(0.4), emu(8.8), emu(0.85),
        txbody(para(name, sz=4000, bold=True), "b"))
    # Role badge
    shapes += rect_shape(sid_base+2, emu(0.45), emu(1.35), emu(3.0), emu(0.38), GREEN)
    shapes += shape(sid_base+3, emu(0.45), emu(1.35), emu(3.0), emu(0.38),
        txbody(para(role, sz=1600, bold=True, color="000000"), "ctr"))
    # Company
    shapes += shape(sid_base+4, emu(3.6), emu(1.4), emu(5.8), emu(0.38),
        txbody(para(f"🏢  {company}", sz=1600), "ctr"))
    # Divider
    shapes += rect_shape(sid_base+5, emu(0.45), emu(1.85), emu(8.6), emu(0.03), "FFFFFF")
    # Skills header
    shapes += shape(sid_base+6, emu(0.45), emu(2.0), emu(4.0), emu(0.45),
        txbody(para("Key Skills", sz=1700, bold=True, color=YELLOW), "b"))
    # Skills
    skills_xml = ""
    for line in skills_lines:
        skills_xml += para(f"◆  {line}", sz=1600, space_before=200)
    shapes += shape(sid_base+7, emu(0.45), emu(2.55), emu(4.1), emu(2.2),
        txbody(skills_xml, "t"))
    # Contribution header
    shapes += shape(sid_base+8, emu(4.8), emu(2.0), emu(4.0), emu(0.45),
        txbody(para("Contribution", sz=1700, bold=True, color=ACCENT), "b"))
    # Contribution
    contrib_xml = ""
    for line in contrib_lines:
        contrib_xml += para(f"◆  {line}", sz=1600, space_before=200)
    shapes += shape(sid_base+9, emu(4.8), emu(2.55), emu(4.1), emu(2.2),
        txbody(contrib_xml, "t"))
    shapes += accent_bar(GREEN)
    return wrap_slide(shapes, 7)


def make_mission():
    """Slide 7 – Mission Statement (like HomeEase slide 2: big bold centered paragraph)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("Mission Statement:", sz=3200, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), YELLOW)
    shapes += shape(12, emu(0.5), emu(1.3), emu(8.7), emu(3.4),
        txbody(para(
            "Our mission is to transform the banking experience through a unified, AI-powered "
            "Agentforce platform that gives every customer a smart, personalised assistant — "
            "capable of checking balances, detecting fraud, processing KYC documents, resolving "
            "disputes, and delivering instant support in any language, 24 × 7, without human "
            "intervention — making world-class banking accessible to every Indian.",
            sz=2100, space_before=0), "ctr"))
    shapes += accent_bar(YELLOW)
    return wrap_slide(shapes, 7)


def make_problem():
    """Slide 8 – The Problem (like HomeEase slide 3: clear pain points)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("The Problem", sz=3200, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), RED)

    problems = [
        ("Fragmented banking channels",
         "Customers must navigate multiple apps, IVR systems, and branches to complete even simple tasks like checking limits or filing a dispute."),
        ("Slow, manual document processing",
         "KYC verification and transaction dispute resolution rely on manual review, causing delays of 5–10 business days and poor customer experience."),
        ("No intelligent personalisation",
         "Existing chatbots follow rigid scripts, cannot understand context, fail in regional languages, and cannot take autonomous actions on behalf of customers."),
    ]
    sid = 12
    for i, (title, desc) in enumerate(problems):
        y = emu(1.35) + i * emu(1.15)
        shapes += rect_shape(sid, emu(0.45), y, emu(0.06), emu(0.85), RED)
        shapes += shape(sid+1, emu(0.65), y, emu(7.8), emu(0.42),
            txbody(para(title, sz=1900, bold=True), "b"))
        shapes += shape(sid+2, emu(0.65), y + emu(0.45), emu(7.8), emu(0.6),
            txbody(para(desc, sz=1600, color="CFD8DC"), "t"))
        sid += 3
    shapes += accent_bar(RED)
    return wrap_slide(shapes, 4)


def make_solution():
    """Slide 9 – The Solution (like HomeEase slide 4: solution statements)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("The Solution", sz=3200, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), GREEN)

    solutions = [
        ("🤖  Agentforce-powered banking AI agent",
         "An always-on AI agent deployed on Salesforce Agentforce that converses naturally, understands intent in English and Hindi, and autonomously executes banking workflows."),
        ("📄  AI document processing",
         "Document AI (IDP) instantly reads uploaded receipts, invoices, and KYC documents, extracts structured data, and triggers downstream processes — zero manual effort."),
        ("⚡  End-to-end automation",
         "From dispute filing to balance enquiry, account statement generation, and KYC approval — all actions run through Salesforce Apex and Flow, fully automated and auditable."),
    ]
    sid = 12
    for i, (title, desc) in enumerate(solutions):
        y = emu(1.35) + i * emu(1.15)
        shapes += rect_shape(sid, emu(0.45), y, emu(0.06), emu(0.85), GREEN)
        shapes += shape(sid+1, emu(0.65), y, emu(7.8), emu(0.42),
            txbody(para(title, sz=1900, bold=True), "b"))
        shapes += shape(sid+2, emu(0.65), y + emu(0.45), emu(7.8), emu(0.6),
            txbody(para(desc, sz=1600, color="CFD8DC"), "t"))
        sid += 3
    shapes += accent_bar(GREEN)
    return wrap_slide(shapes, 4)


def make_technology():
    """Slide 10 – The Technology (like HomeEase slide 5: big heading + tech list)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("The Technology:", sz=3200, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), YELLOW)

    techs = [
        ("Agentforce (GenAI Planner)", "Autonomous AI agent with ReAct reasoning"),
        ("Salesforce Service Cloud", "Core CRM, Case Management, Omnichannel"),
        ("Document AI / IDP", "PDF extraction, KYC & receipt processing"),
        ("Apex & Flows", "Transaction processing, dispute filing, account ops"),
        ("Experience Cloud", "Customer portal & chat interface"),
        ("LWC", "Custom UI components for banking dashboard"),
    ]
    col1 = techs[:3]
    col2 = techs[3:]
    for col_i, col in enumerate([col1, col2]):
        cx = emu(0.5) + col_i * emu(4.6)
        for row_i, (tech, desc) in enumerate(col):
            cy = emu(1.35) + row_i * emu(1.1)
            shapes += rect_shape(20 + col_i*10 + row_i, cx, cy, emu(0.06), emu(0.8), YELLOW)
            shapes += shape(30 + col_i*10 + row_i, cx + emu(0.2), cy, emu(4.0), emu(0.4),
                txbody(para(tech, sz=1800, bold=True), "b"))
            shapes += shape(40 + col_i*10 + row_i, cx + emu(0.2), cy + emu(0.42), emu(4.0), emu(0.4),
                txbody(para(desc, sz=1500, color="B0BEC5"), "t"))
    shapes += accent_bar(YELLOW)
    return wrap_slide(shapes, 4)


def make_how_it_works_1():
    """Slide 11 – How It Works Part 1 (Steps 1–3, like HomeEase slide 6)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("How It Works", sz=3200, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), ACCENT)

    steps = [
        ("Step 1", "Customer initiates via chat",
         "Agentforce AI Agent greets the customer on Experience Cloud chat, detects intent (balance, dispute, KYC, statement), and creates or updates a Salesforce Case."),
        ("Step 2", "Intelligent action dispatch",
         "The GenAI Planner selects the right Apex action (GetAccountBalance, FileDispute, ProcessDocumentAI) using ReAct reasoning and executes it with customer data."),
        ("Step 3", "Document AI triggered on upload",
         "When customer uploads a PDF (receipt / ID), the agent immediately calls Document AI Universal Extractor, parses structured fields, and populates the Case record."),
    ]
    sid = 20
    for i, (step, title, desc) in enumerate(steps):
        y = emu(1.35) + i * emu(1.15)
        shapes += rect_shape(sid, emu(0.45), y, emu(1.0), emu(0.85), CARD_BG)
        shapes += shape(sid+1, emu(0.45), y, emu(1.0), emu(0.85),
            txbody(para(step, sz=1500, bold=True, color=ACCENT), "ctr"))
        shapes += shape(sid+2, emu(1.6), y, emu(2.8), emu(0.42),
            txbody(para(title, sz=1800, bold=True), "b"))
        shapes += shape(sid+3, emu(1.6), y + emu(0.44), emu(6.9), emu(0.58),
            txbody(para(desc, sz=1500, color="CFD8DC"), "t"))
        sid += 4
    shapes += accent_bar(ACCENT)
    return wrap_slide(shapes, 3)


def make_how_it_works_2():
    """Slide 12 – How It Works Part 2 (Steps 4–6, like HomeEase slide 7)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("How It Works", sz=3200, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), ACCENT)

    steps = [
        ("Step 4", "Multilingual response delivery",
         "The agent responds in English or Hindi based on customer preference. All responses are grounded in live Salesforce data — account balance, transaction history, dispute status."),
        ("Step 5", "Autonomous dispute & KYC resolution",
         "For disputes: agent asks for receipt → extracts amount via Document AI → files Case with one Apex call. For KYC: extracts ID fields → updates Contact record → triggers approval Flow."),
        ("Step 6", "Escalation & human handoff",
         "For complex issues the agent creates a priority Case, assigns to a human agent via Omnichannel routing, and sends an automated summary email — fully logged and auditable."),
    ]
    sid = 20
    for i, (step, title, desc) in enumerate(steps):
        y = emu(1.35) + i * emu(1.15)
        shapes += rect_shape(sid, emu(0.45), y, emu(1.0), emu(0.85), CARD_BG)
        shapes += shape(sid+1, emu(0.45), y, emu(1.0), emu(0.85),
            txbody(para(step, sz=1500, bold=True, color=ACCENT), "ctr"))
        shapes += shape(sid+2, emu(1.6), y, emu(2.8), emu(0.42),
            txbody(para(title, sz=1800, bold=True), "b"))
        shapes += shape(sid+3, emu(1.6), y + emu(0.44), emu(6.9), emu(0.58),
            txbody(para(desc, sz=1500, color="CFD8DC"), "t"))
        sid += 4
    shapes += accent_bar(ACCENT)
    return wrap_slide(shapes, 3)


def make_business_benefits():
    """Slide 13 – Business Benefits (like HomeEase slide 8)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("Business Benefits:", sz=3200, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), GREEN)

    benefits = [
        "Reduce dispute resolution time from 5–10 days to under 5 minutes with AI-driven Document AI automation.",
        "Eliminate 70% of routine call centre load — balance enquiries, statements, and KYC handled entirely by the AI agent.",
        "Personalised, AI-driven customer experience with multilingual support (English + Hindi) and 24 × 7 availability.",
        "Unified banking ecosystem on a single Salesforce platform — CRM, AI, Documents, Flows, and Analytics all connected.",
    ]
    for i, benefit in enumerate(benefits):
        y = emu(1.3) + i * emu(0.9)
        shapes += rect_shape(20+i, emu(0.45), y + emu(0.2), emu(0.5), emu(0.5), GREEN)
        shapes += shape(30+i, emu(0.45), y + emu(0.18), emu(0.5), emu(0.5),
            txbody(para(str(i+1), sz=1800, bold=True, color="000000"), "ctr"))
        shapes += shape(40+i, emu(1.1), y, emu(7.7), emu(0.85),
            txbody(para(benefit, sz=1700), "ctr"))
    shapes += accent_bar(GREEN)
    return wrap_slide(shapes, 7)


def make_demo_before():
    """Slide 14 – Demo Story: Before (like HomeEase slide 9)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("Demo Story: Banking Experience Reimagined", sz=2800, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), RED)
    shapes += shape(12, emu(0.5), emu(1.2), emu(9.0), emu(0.45),
        txbody(para("Before (Traditional Banking):", sz=2200, bold=True, color=RED), "b"))
    shapes += shape(13, emu(0.5), emu(1.75), emu(8.6), emu(2.8),
        txbody(para(
            "Rahul (customer) notices a suspicious Rs 4,500 debit on his credit card. "
            "He calls the bank helpline — waits 25 minutes on hold. The IVR cannot understand his "
            "query and transfers him three times. He is finally asked to visit a branch with "
            "physical copies of his bill. He fills a paper form, submits it, and is told resolution "
            "takes 7–10 working days. He has no visibility into the status of his dispute. "
            "Meanwhile his limit is blocked. He is frustrated and considers switching banks.",
            sz=1900), "t"))
    shapes += accent_bar(RED)
    return wrap_slide(shapes, 4)


def make_demo_after():
    """Slide 15 – Demo Story: After (like HomeEase slide 10)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("Demo Story: Banking Experience Reimagined", sz=2800, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), GREEN)
    shapes += shape(12, emu(0.5), emu(1.2), emu(9.0), emu(0.45),
        txbody(para("After (Bharat AI Bank — Agentforce-powered):", sz=2200, bold=True, color=GREEN), "b"))

    after = [
        ("Rahul (Customer)",
         "Opens chat → says 'I want to dispute a transaction' → AI agent asks for receipt → uploads PDF → agent calls Document AI, extracts Rs 4,500 → dispute filed in Salesforce in 90 seconds."),
        ("AI Agent",
         "Responds in Hindi when Rahul switches language, checks account balance live, sends Case number, and proactively notifies Rahul of dispute status via chat."),
        ("Bank Operations",
         "Zero manual intervention — Case auto-assigned to fraud team if needed, full audit trail in Salesforce, compliance reports auto-generated."),
    ]
    sid = 20
    for i, (actor, action) in enumerate(after):
        y = emu(1.75) + i * emu(1.05)
        shapes += rect_shape(sid, emu(0.45), y, emu(1.8), emu(0.4), CARD_BG)
        shapes += shape(sid+1, emu(0.45), y, emu(1.8), emu(0.4),
            txbody(para(actor, sz=1600, bold=True, color=GREEN), "ctr"))
        shapes += shape(sid+2, emu(2.4), y, emu(6.5), emu(0.9),
            txbody(para(action, sz=1600), "ctr"))
        sid += 3
    shapes += accent_bar(GREEN)
    return wrap_slide(shapes, 4)


def make_outcome():
    """Slide 16 – Outcomes (like HomeEase slide 11)"""
    shapes = ""
    shapes += shape(10, emu(0.5), emu(0.3), emu(9.0), emu(0.65),
        txbody(para("Demo Story: Banking Experience Reimagined", sz=2800, bold=True), "b"))
    shapes += rect_shape(11, emu(0.5), emu(1.05), emu(8.15), emu(0.04), YELLOW)
    shapes += shape(12, emu(0.5), emu(1.2), emu(9.0), emu(0.4),
        txbody(para("Outcome:", sz=2200, bold=True, color=YELLOW), "b"))

    outcomes = [
        "Dispute resolved in under 2 minutes",
        "Zero branch visit required",
        "AI agent handled entirely in Hindi",
        "KYC verified & approved in same session",
        "Customer satisfaction: instant, transparent, effortless",
    ]
    col1 = outcomes[:3]
    col2 = outcomes[3:]
    for col_i, col in enumerate([col1, col2]):
        cx = emu(0.5) + col_i * emu(4.6)
        for row_i, outcome in enumerate(col):
            cy = emu(1.75) + row_i * emu(0.85)
            shapes += rect_shape(20 + col_i*10 + row_i, cx, cy + emu(0.2), emu(0.35), emu(0.35), YELLOW)
            shapes += shape(30 + col_i*10 + row_i, cx, cy + emu(0.2), emu(0.35), emu(0.35),
                txbody(para("✓", sz=1400, bold=True, color="000000"), "ctr"))
            shapes += shape(40 + col_i*10 + row_i, cx + emu(0.5), cy, emu(3.9), emu(0.75),
                txbody(para(outcome, sz=1700), "ctr"))
    shapes += accent_bar(YELLOW)
    return wrap_slide(shapes, 4)


def make_thankyou():
    """Slide 17 – Thank You"""
    shapes = ""
    shapes += rect_shape(10, 0, 0, W, emu(0.2), YELLOW)
    shapes += shape(11, emu(0.5), emu(1.2), emu(9.1), emu(1.0),
        txbody(para("Thank You!", sz=5400, bold=True), "ctr"))
    shapes += rect_shape(12, emu(3.5), emu(2.4), emu(3.15), emu(0.05), YELLOW)
    shapes += shape(13, emu(0.5), emu(2.65), emu(9.1), emu(0.55),
        txbody(para("Team AgentX Innovators  |  Accenture  |  2025", sz=2000), "ctr"))
    shapes += shape(14, emu(0.5), emu(3.3), emu(9.1), emu(0.45),
        txbody(para("Princy Shah  •  Shraddha Dere  •  Ankur Omar  •  Ravi Kamal", sz=1700, color="B0BEC5"), "ctr"))
    shapes += shape(15, emu(0.5), emu(3.9), emu(9.1), emu(0.4),
        txbody(para("GitHub: github.com/princy2806/Bharat-AI-Bank", sz=1600, color=ACCENT), "ctr"))
    shapes += accent_bar(YELLOW)
    return wrap_slide(shapes, 1)


# ──────────────────────────────────────────────────────────────────────────────
# Individual member slides
def make_princy():
    return make_member(100, "Princy Shah",
        "Salesforce Tech Lead", "Accenture",
        ["Salesforce Agentforce & GenAI", "Apex & LWC Development",
         "Experience Cloud", "Document AI / IDP", "Integration (REST/SOAP)"],
        ["Architected the GenAI Planner bundle", "Built ProcessDocumentAI Apex",
         "Designed dispute & KYC flows", "Led overall technical delivery"])

def make_shraddha():
    return make_member(200, "Shraddha Dere",
        "Salesforce Tech Lead", "Accenture",
        ["Salesforce Agentforce & GenAI", "Apex & LWC Development",
         "Experience Cloud", "Document AI / IDP", "Integration (REST/SOAP)"],
        ["Developed Agentforce topic instructions", "Built account & statement actions",
         "Implemented multilingual agent flow", "Testing & quality assurance"])

def make_ankur():
    return make_member(300, "Ankur Omar",
        "Salesforce Manager", "Accenture",
        ["Solution Architecture", "BFSI Domain Expertise",
         "Salesforce Platform Strategy", "Integration Design",
         "Stakeholder Management"],
        ["Defined overall solution architecture", "Designed banking use-case scenarios",
         "Mapped BFSI compliance requirements", "Demo story & presentation lead"])

def make_ravi():
    return make_member(400, "Ravi Kamal",
        "Salesforce Tech Lead", "Accenture",
        ["Experience Cloud", "LWC & Styling", "Salesforce Flows",
         "Omnichannel Configuration", "Demo Preparation"],
        ["Built Experience Cloud chat portal", "Designed UI/UX components",
         "Configured Omnichannel routing", "Created and recorded demo video"])


# ──────────────────────────────────────────────────────────────────────────────
# Assemble final PPTX

all_slides = [
    (make_cover(),              1, "Cover"),
    (make_team_overview(),      3, "Team Overview"),
    (make_princy(),             7, "Princy Shah"),
    (make_shraddha(),           7, "Shraddha Dere"),
    (make_ankur(),              7, "Ankur Omar"),
    (make_ravi(),               7, "Ravi Kamal"),
    (make_mission(),            7, "Mission Statement"),
    (make_problem(),            4, "The Problem"),
    (make_solution(),           4, "The Solution"),
    (make_technology(),         4, "The Technology"),
    (make_how_it_works_1(),     3, "How It Works (1)"),
    (make_how_it_works_2(),     3, "How It Works (2)"),
    (make_business_benefits(),  7, "Business Benefits"),
    (make_demo_before(),        4, "Demo Story - Before"),
    (make_demo_after(),         4, "Demo Story - After"),
    (make_outcome(),            4, "Demo Story - Outcome"),
    (make_thankyou(),           1, "Thank You"),
]

N = len(all_slides)

# ── Build presentation.xml ──────────────────────────────────────────────────
with zipfile.ZipFile(SRC, 'r') as src_zip:
    src_pres = src_zip.read('ppt/presentation.xml').decode('utf-8')

# Inject slide list
sldid_list = ''.join(
    f'<p:sldId id="{256+i}" r:id="rId{8+i}"/>' for i in range(N)
)
new_pres = re.sub(r'<p:sldIdLst>.*?</p:sldIdLst>',
                   f'<p:sldIdLst>{sldid_list}</p:sldIdLst>',
                   src_pres, flags=re.DOTALL)

# ── Build presentation.xml.rels ─────────────────────────────────────────────
with zipfile.ZipFile(SRC, 'r') as src_zip:
    src_pres_rels = src_zip.read('ppt/_rels/presentation.xml.rels').decode('utf-8')

# Remove old slide relationships, keep everything else
src_pres_rels_clean = re.sub(
    r'<Relationship[^/]*/slides/slide\d+\.xml[^/]*/>', '', src_pres_rels)
# Insert before closing tag
new_slide_rels = ''.join(
    f'<Relationship Id="rId{8+i}" '
    f'Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" '
    f'Target="slides/slide{i+1}.xml"/>'
    for i in range(N)
)
new_pres_rels = src_pres_rels_clean.replace(
    '</Relationships>', new_slide_rels + '</Relationships>')

# ── Build [Content_Types].xml ───────────────────────────────────────────────
with zipfile.ZipFile(SRC, 'r') as src_zip:
    src_ct = src_zip.read('[Content_Types].xml').decode('utf-8')

# Remove old slide overrides
src_ct_clean = re.sub(
    r'<Override PartName="/ppt/slides/slide\d+\.xml"[^/]*/>',
    '', src_ct)
# Remove old notesSlide overrides too
src_ct_clean = re.sub(
    r'<Override PartName="/ppt/notesSlides/notesSlide\d+\.xml"[^/]*/>',
    '', src_ct_clean)
new_overrides = ''.join(
    f'<Override PartName="/ppt/slides/slide{i+1}.xml" '
    f'ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>'
    for i in range(N)
)
new_ct = src_ct_clean.replace('</Types>', new_overrides + '</Types>')

# ── Write output PPTX ───────────────────────────────────────────────────────
SKIP_PREFIXES = ('ppt/slides/', 'ppt/notesSlides/')
SKIP_EXACT    = ('ppt/presentation.xml', 'ppt/_rels/presentation.xml.rels',
                 '[Content_Types].xml')

with zipfile.ZipFile(SRC, 'r') as src_zip, \
     zipfile.ZipFile(DEST, 'w', zipfile.ZIP_DEFLATED) as out_zip:

    # Copy everything except slides/notes/pres files we're replacing
    for name in src_zip.namelist():
        if name in SKIP_EXACT:
            continue
        skip = any(name.startswith(p) for p in SKIP_PREFIXES)
        if skip:
            continue
        out_zip.writestr(name, src_zip.read(name))

    # Write replaced files
    out_zip.writestr('ppt/presentation.xml',           new_pres.encode('utf-8'))
    out_zip.writestr('ppt/_rels/presentation.xml.rels', new_pres_rels.encode('utf-8'))
    out_zip.writestr('[Content_Types].xml',             new_ct.encode('utf-8'))

    # Write each new slide + its rels
    for i, (xml_str, layout_num, title) in enumerate(all_slides):
        slide_name = f'ppt/slides/slide{i+1}.xml'
        rels_name  = f'ppt/slides/_rels/slide{i+1}.xml.rels'
        out_zip.writestr(slide_name, xml_str.encode('utf-8'))
        out_zip.writestr(rels_name,  slide_rels(layout_num).encode('utf-8'))

print(f"✅  PPT created: {DEST}")
print(f"   Slides: {N}")
size_kb = os.path.getsize(DEST) // 1024
print(f"   Size:   {size_kb} KB")
print()
print("Slide list:")
for i, (_, _, title) in enumerate(all_slides):
    print(f"  {i+1:2}. {title}")
