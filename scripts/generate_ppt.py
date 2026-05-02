"""
Generate Bharat AI Bank – Team Presentation PPT
Uses only Python standard library (no external dependencies)
"""
import zipfile, os, textwrap
from pathlib import Path

OUT = Path(r"C:\Users\princy.shah\Documents\Agentforce_Hackathon\scripts\Bharat_AI_Bank_Presentation.pptx")

# ── COLOURS ──────────────────────────────────────────────────────
NAVY   = "001F4D"
BLUE   = "0057B8"
GOLD   = "D4A017"
WHITE  = "FFFFFF"
LGREY  = "F0F4FF"
DARK   = "050D1A"
GREEN  = "10B981"
PURPLE = "7C3AED"

# ── TEAM DATA ────────────────────────────────────────────────────
TEAM = [
    {
        "name":    "Princy Shah",
        "initials":"PS",
        "role":    "Salesforce Tech Lead",
        "org":     "Accenture",
        "color":   BLUE,
        "emoji":   "👩‍💻",
        "skills":  "Agentforce · Apex · LWC · Experience Cloud · Document AI · WhatsApp API",
        "contribs": [
            ("🤖", "GenAI Planner Bundle", "5-topic agent with multilingual ReAct reasoning"),
            ("📄", "Einstein Document AI", "ProcessDocumentAIUniversal + IDP Credit_Card_Details"),
            ("⚡", "6 Custom Apex Actions", "FileCardDispute, EMISimulator, GetAccountBalance..."),
            ("🌐", "Experience Cloud LWC", "bharatBankDashboard with animated UI"),
            ("💬", "WhatsApp Integration", "Enhanced Messaging + WABA configuration"),
            ("🚀", "Full Stack Deployment", "Salesforce CLI, metadata, org config"),
        ],
    },
    {
        "name":    "Shraddha Dere",
        "initials":"SD",
        "role":    "Salesforce Tech Lead",
        "org":     "Accenture",
        "color":   "C07D10",
        "emoji":   "👩‍💻",
        "skills":  "Agentforce · Apex · LWC · Experience Cloud · Document AI · Testing & QA",
        "contribs": [
            ("🤖", "GenAI Planner Bundle", "Co-developed agent topics, instructions, action flows"),
            ("⚡", "Apex Development", "Built and tested custom invocable Apex actions"),
            ("🌐", "LWC Components", "Lightning Web Components for Experience Cloud portal"),
            ("📄", "Document AI Integration", "IDP configuration and document extraction pipeline"),
            ("🧪", "Testing & QA", "End-to-end testing across Hindi, English, Hinglish"),
            ("☁️", "Experience Cloud Setup", "Site settings, navigation, embedded chat config"),
        ],
    },
    {
        "name":    "Ankur Omar",
        "initials":"AO",
        "role":    "Salesforce Manager",
        "org":     "Accenture",
        "color":   "5B21B6",
        "emoji":   "👨‍💼",
        "skills":  "Solution Architecture · BFSI Domain · Integration Design · Data Modelling · Project Management",
        "contribs": [
            ("🏗️", "Salesforce Architecture", "End-to-end technical architecture design"),
            ("🔗", "Integration Design", "OAuth 2.0, Document AI API, WhatsApp WABA patterns"),
            ("🏦", "BFSI Domain Expertise", "Banking workflows for dispute, EMI and KYC"),
            ("🎯", "Project Leadership", "Team delivery, feature prioritisation, requirements"),
            ("🗄️", "Data Model Design", "Person Accounts, Cases, ContentDocuments"),
            ("📋", "Solution Review", "Validated agent instructions and Apex logic"),
        ],
    },
    {
        "name":    "Ravi Kamal",
        "initials":"RK",
        "role":    "Salesforce Tech Lead",
        "org":     "Accenture",
        "color":   "065F46",
        "emoji":   "👨‍🎨",
        "skills":  "LWC · Experience Cloud · CSS Animation · UI/UX Design · Demo Scripting · Video Production",
        "contribs": [
            ("🎨", "LWC Styling & UI", "Navy/gold brand, animated hero, account cards, FAB"),
            ("🌐", "Experience Cloud Setup", "Templates, navigation, head markup CSS, page layouts"),
            ("🗺️", "User Journey Mapping", "End-to-end journeys for all 3 demo scenarios"),
            ("🎬", "Demo Video", "Scripted and recorded 5-min demo in Hindi & English"),
            ("📊", "Presentation Design", "Submission PDF and team presentation slides"),
            ("🧪", "Demo Testing", "All scenarios tested with Rajesh Sharma test data"),
        ],
    },
]

# ── HELPERS ──────────────────────────────────────────────────────
def emu(pt):   return str(int(pt * 12700))
def pt(n):     return str(int(n * 100))
def rgb(c):    return f'<a:srgbClr val="{c}"/>'

def solidFill(c):
    return f'<a:solidFill>{rgb(c)}</a:solidFill>'

def run(text, bold=False, size=18, color=WHITE, font="Inter"):
    b = "<a:b/>" if bold else ""
    return f"""
<a:r>
  <a:rPr lang="en-US" sz="{pt(size)}" b="{1 if bold else 0}" dirty="0">
    <a:solidFill>{rgb(color)}</a:solidFill>
    <a:latin typeface="{font}"/>
  </a:rPr>
  <a:t>{text}</a:t>
</a:r>"""

def para(runs_xml, align="l", space_before=0):
    spcBef = f'<a:spcBef><a:spcPts val="{space_before*100}"/></a:spcBef>' if space_before else ""
    return f"""
<a:p>
  <a:pPr algn="{align}">{spcBef}</a:pPr>
  {runs_xml}
</a:p>"""

def txBox(x, y, w, h, *paras):
    return f"""
<p:sp>
  <p:nvSpPr>
    <p:cNvPr id="1" name="tb"/>
    <p:cNvSpPr txBox="1"/>
    <p:nvPr/>
  </p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(x)}" y="{emu(y)}"/><a:ext cx="{emu(w)}" cy="{emu(h)}"/></a:xfrm>
    <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
    <a:noFill/>
  </p:spPr>
  <p:txBody>
    <a:bodyPr wrap="square" lIns="0" rIns="0" tIns="0" bIns="0"/>
    <a:lstStyle/>
    {''.join(paras)}
  </p:txBody>
</p:sp>"""

def rect(x, y, w, h, fill, rx=0):
    prstGeom = f'<a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val {rx}"/></a:avLst></a:prstGeom>' if rx else '<a:prstGeom prst="rect"><a:avLst/></a:prstGeom>'
    return f"""
<p:sp>
  <p:nvSpPr><p:cNvPr id="2" name="rect"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(x)}" y="{emu(y)}"/><a:ext cx="{emu(w)}" cy="{emu(h)}"/></a:xfrm>
    {prstGeom}
    <a:solidFill>{rgb(fill)}</a:solidFill>
    <a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody><a:bodyPr/><a:lstStyle/><a:p/></p:txBody>
</p:sp>"""

def circle(x, y, d, fill):
    return f"""
<p:sp>
  <p:nvSpPr><p:cNvPr id="3" name="circ"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{emu(x)}" y="{emu(y)}"/><a:ext cx="{emu(d)}" cy="{emu(d)}"/></a:xfrm>
    <a:prstGeom prst="ellipse"><a:avLst/></a:prstGeom>
    <a:solidFill>{rgb(fill)}</a:solidFill>
    <a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody><a:bodyPr/><a:lstStyle/><a:p/></p:txBody>
</p:sp>"""

SLIDE_W, SLIDE_H = 914.4, 514.35  # pts  (13.33 x 7.5 in)

def slide_xml(shapes):
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
       xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <p:cSld><p:spTree>
    <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
    <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>
      <a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
    {''.join(shapes)}
  </p:spTree></p:cSld>
</p:sld>"""

# ── SLIDE BUILDERS ────────────────────────────────────────────────

def build_cover():
    shapes = [
        # Background
        rect(0, 0, SLIDE_W, SLIDE_H, NAVY),
        # Gold accent bar top
        rect(0, 0, SLIDE_W, 6, GOLD),
        # Decorative circles
        circle(720, -60, 280, "0A3580"),
        circle(-60, 320, 200, "0A2560"),
        # Hackathon badge
        rect(307, 40, 300, 28, "1A3560", rx=20000),
        txBox(307, 40, 300, 28,
              para(run("🏆  AGENTFORCE HACKATHON 2026", bold=True, size=9, color=GOLD), align="ctr")),
        # Title
        txBox(50, 90, SLIDE_W-100, 80,
              para(run("Bharat ", bold=True, size=52, color=WHITE) +
                   run("AI ", bold=True, size=52, color=GOLD) +
                   run("Bank", bold=True, size=52, color=WHITE), align="ctr")),
        # Subtitle
        txBox(100, 178, SLIDE_W-200, 40,
              para(run("India's First AI-Powered Multilingual Banking Self-Service Agent", size=14, color="A0C4FF"), align="ctr")),
        txBox(100, 210, SLIDE_W-200, 30,
              para(run("Built on Salesforce Agentforce + Einstein Document AI", size=12, color="7090B0"), align="ctr")),
        # Divider
        rect(387, 250, 140, 2, GOLD),
        # Pills
        rect(60,  268, 168, 26, "0A3070", rx=20000),
        rect(244, 268, 140, 26, "0A3070", rx=20000),
        rect(400, 268, 192, 26, "0A3070", rx=20000),
        rect(608, 268, 200, 26, "0A3070", rx=20000),
        txBox(60,  268, 168, 26, para(run("🤖  Agentforce", size=10, color="93C5FD"), align="ctr")),
        txBox(244, 268, 140, 26, para(run("📄  Document AI", size=10, color="93C5FD"), align="ctr")),
        txBox(400, 268, 192, 26, para(run("💬  WhatsApp + Exp Cloud", size=10, color="93C5FD"), align="ctr")),
        txBox(608, 268, 200, 26, para(run("🇮🇳  Hindi · English · Hinglish", size=10, color="93C5FD"), align="ctr")),
        # Team label
        txBox(100, 318, SLIDE_W-200, 20,
              para(run("PRESENTED BY", size=8, color="506080"), align="ctr")),
        txBox(100, 336, SLIDE_W-200, 32,
              para(run("Team AgentX Innovators", bold=True, size=20, color=WHITE), align="ctr")),
        # Bottom bar
        rect(0, SLIDE_H-18, SLIDE_W, 18, "000D28"),
        txBox(20, SLIDE_H-16, 400, 14,
              para(run("🏦  Bharat AI Bank  ·  AgentX Innovators  ·  Accenture", size=7, color="506080"))),
        txBox(SLIDE_W-80, SLIDE_H-16, 70, 14,
              para(run("01 / 11", size=7, color="506080"), align="r")),
    ]
    return slide_xml(shapes)


def build_team_overview():
    shapes = [
        rect(0, 0, SLIDE_W, SLIDE_H, DARK),
        rect(0, 0, SLIDE_W, 4, GOLD),
        # Header
        txBox(40, 22, 400, 16, para(run("MEET THE TEAM", size=9, color=GOLD, bold=True))),
        txBox(40, 38, 600, 36, para(run("The ", bold=True, size=26, color=WHITE) +
                                    run("Builders", bold=True, size=26, color=GOLD) +
                                    run(" Behind Bharat AI Bank", bold=True, size=26, color=WHITE))),
    ]
    # 4 member cards
    members_short = [
        (TEAM[0], BLUE,   "001233"),
        (TEAM[1], "C07D10", "1A0A00"),
        (TEAM[2], "5B21B6", "1A0040"),
        (TEAM[3], "065F46", "012A1A"),
    ]
    card_w = 202
    for i, (m, accent, bg) in enumerate(members_short):
        x = 40 + i * (card_w + 14)
        y = 88
        shapes += [
            rect(x, y, card_w, 390, bg, rx=12000),
            rect(x, y, card_w, 4, accent),
            circle(x + card_w//2 - 32, y + 14, 64, accent),
            txBox(x, y + 16, card_w, 34,
                  para(run(m["initials"], bold=True, size=22, color=WHITE), align="ctr")),
            txBox(x+6, y + 84, card_w-12, 22,
                  para(run(m["name"], bold=True, size=13, color=WHITE), align="ctr")),
            txBox(x+6, y + 104, card_w-12, 18,
                  para(run(m["role"], size=10, color="60A5FA"), align="ctr")),
            txBox(x+6, y + 120, card_w-12, 14,
                  para(run(m["org"], size=9, color="607080"), align="ctr")),
        ]
        # contrib bullets
        for j, (icon, title, _desc) in enumerate(m["contribs"][:5]):
            shapes.append(txBox(x+10, y+140+j*40, card_w-16, 36,
                  para(run(f"{icon} {title}", bold=True, size=9.5, color="D1D5DB")) +
                  para(run(_desc[:42], size=8.5, color="607080"))))

    shapes += [
        rect(0, SLIDE_H-18, SLIDE_W, 18, "000D28"),
        txBox(20, SLIDE_H-16, 400, 14, para(run("🏦  Bharat AI Bank  ·  AgentX Innovators", size=7, color="506080"))),
        txBox(SLIDE_W-80, SLIDE_H-16, 70, 14, para(run("02 / 11", size=7, color="506080"), align="r")),
    ]
    return slide_xml(shapes)


def build_member_slide(member, index, total=11):
    accent = member["color"]
    shapes = [
        rect(0, 0, SLIDE_W, SLIDE_H, DARK),
        # Left panel
        rect(0, 0, 295, SLIDE_H, "0" + accent if len(accent)==5 else accent[:2]+"0"+accent[2:]),
        rect(0, 0, 295, 4, accent),
        # Avatar circle
        circle(295//2 - 52, 36, 104, accent),
        txBox(0, 46, 295, 58,
              para(run(member["initials"], bold=True, size=36, color=WHITE), align="ctr")),
        # Name & role
        txBox(10, 150, 275, 28,
              para(run(member["name"], bold=True, size=17, color=WHITE), align="ctr")),
        txBox(10, 176, 275, 20,
              para(run(member["role"], size=11, color="A0C4FF"), align="ctr")),
        txBox(10, 194, 275, 16,
              para(run(member["org"], size=10, color="607080"), align="ctr")),
        # Divider
        rect(60, 216, 175, 1, accent),
        # Skills label
        txBox(10, 222, 275, 14,
              para(run("SKILLS", bold=True, size=8, color=GOLD), align="ctr")),
    ]
    # Skill tags (word-wrap into lines)
    skills = member["skills"].split(" · ")
    sy = 238
    row = []
    for s in skills:
        row.append(s)
        if len(row) == 2:
            shapes.append(txBox(14, sy, 267, 20,
                  para(run("  ·  ".join(row), size=9, color="93C5FD"), align="ctr")))
            sy += 22
            row = []
    if row:
        shapes.append(txBox(14, sy, 267, 20,
              para(run(row[0], size=9, color="93C5FD"), align="ctr")))

    # Right panel
    shapes += [
        txBox(312, 18, 100, 14, para(run(f"TEAM MEMBER  ·  {index:02d}", size=8, color="506080"))),
        txBox(312, 32, 550, 36,
              para(run(member["name"], bold=True, size=24, color=WHITE))),
        txBox(312, 66, 550, 16,
              para(run("Accenture  ·  AgentX Innovators", size=10, color="607080"))),
        # Section title
        txBox(312, 90, 300, 14, para(run("KEY CONTRIBUTIONS", bold=True, size=8, color=GOLD))),
        rect(312, 106, 550, 1, "1A2A3A"),
    ]
    # Contribution cards in 2×3 grid
    card_w2, card_h2 = 266, 76
    for j, (icon, title, desc) in enumerate(member["contribs"]):
        col = j % 2
        row2 = j // 2
        cx = 312 + col * (card_w2 + 18)
        cy = 112 + row2 * (card_h2 + 10)
        shapes += [
            rect(cx, cy, card_w2, card_h2, "0A1525", rx=8000),
            txBox(cx+8, cy+6, card_w2-14, 24,
                  para(run(f"{icon}  {title}", bold=True, size=11, color=WHITE))),
            txBox(cx+8, cy+28, card_w2-14, 42,
                  para(run(desc, size=9.5, color="8090A0"))),
        ]

    shapes += [
        rect(0, SLIDE_H-18, SLIDE_W, 18, "000D28"),
        txBox(20, SLIDE_H-16, 400, 14, para(run("🏦  Bharat AI Bank  ·  AgentX Innovators", size=7, color="506080"))),
        txBox(SLIDE_W-80, SLIDE_H-16, 70, 14,
              para(run(f"{index+2:02d} / {total}", size=7, color="506080"), align="r")),
    ]
    return slide_xml(shapes)


def build_project_highlights():
    highlights = [
        (BLUE,   "🏦", "Real-Time Balance & Statement",
         "Live balances: savings, credit card, MF, mortgage. Mini statement — last 5 txns in Hindi or English."),
        (GOLD,   "📄", "Einstein Document AI",
         "Upload any receipt — AI extracts Amount, Merchant, Date using IDP Credit_Card_Details config."),
        (GREEN,  "💳", "Dispute Filing in 2 Minutes",
         "Upload receipt → AI extracts → case created → provisional credit applied. Zero branch visits."),
        ("7C3AED","📊", "EMI Restructuring Simulator",
         "Instant 3-option simulation with exact figures. RM callback scheduled automatically."),
        ("EF4444","🇮🇳", "Multilingual — Hindi First",
         "Full native Hindi support. Auto-detects language. No selection needed. Serves Bharat."),
        (BLUE,   "💬", "WhatsApp + Experience Cloud",
         "Works on WhatsApp Enhanced Messaging AND Experience Cloud chat. Same agent, 2 channels."),
    ]
    shapes = [
        rect(0, 0, SLIDE_W, SLIDE_H, DARK),
        rect(0, 0, SLIDE_W, 4, GOLD),
        txBox(40, 22, 400, 16, para(run("WHAT WE BUILT", size=9, color=GOLD, bold=True))),
        txBox(40, 38, 700, 36, para(run("Project ", bold=True, size=26, color=WHITE) +
                                    run("Highlights", bold=True, size=26, color=GOLD))),
    ]
    cw, ch = 278, 118
    for i, (color, icon, title, desc) in enumerate(highlights):
        col, row2 = i % 3, i // 3
        x = 40 + col * (cw + 20)
        y = 90 + row2 * (ch + 14)
        shapes += [
            rect(x, y, cw, ch, "0A1525", rx=10000),
            rect(x, y, 4, ch, color),
            txBox(x+16, y+10, cw-24, 28, para(run(f"{icon}  {title}", bold=True, size=12, color=WHITE))),
            txBox(x+16, y+36, cw-24, 72, para(run(desc, size=9.5, color="8090A0"))),
        ]
    shapes += [
        rect(0, SLIDE_H-18, SLIDE_W, 18, "000D28"),
        txBox(20, SLIDE_H-16, 400, 14, para(run("🏦  Bharat AI Bank  ·  AgentX Innovators", size=7, color="506080"))),
        txBox(SLIDE_W-80, SLIDE_H-16, 70, 14, para(run("07 / 11", size=7, color="506080"), align="r")),
    ]
    return slide_xml(shapes)


def build_tech_stack():
    layers = [
        ("AI & Agent",  "0057B8", ["Salesforce Agentforce", "GenAI Planner Bundle (ReAct)", "Einstein Document AI", "IDP — Credit_Card_Details", "Doc Processing API v64.0"]),
        ("Backend",     "065F46", ["ProcessDocumentAIUniversal", "FileCardDispute", "EMISimulator", "ScheduleRMCallback", "GetAccountBalance", "GetDisputeStatus"]),
        ("Frontend",    "7C3AED", ["Lightning Web Components", "Experience Cloud", "Embedded Service Chat", "CSS Animations"]),
        ("Channels",    "D4A017", ["WhatsApp Enhanced Messaging", "WhatsApp Business (WABA)", "Service Cloud Cases", "ContentDocuments"]),
        ("DevOps",      "EF4444", ["Salesforce CLI", "GitHub – princy2806/Bharat-AI-Bank", "VS Code + SF Extensions", "OAuth 2.0 Client Credentials"]),
    ]
    shapes = [
        rect(0, 0, SLIDE_W, SLIDE_H, DARK),
        rect(0, 0, SLIDE_W, 4, GOLD),
        txBox(40, 22, 400, 16, para(run("UNDER THE HOOD", size=9, color=GOLD, bold=True))),
        txBox(40, 38, 700, 36, para(run("Technology ", bold=True, size=26, color=WHITE) +
                                    run("Stack", bold=True, size=26, color=GOLD))),
    ]
    for i, (label, color, items) in enumerate(layers):
        y = 90 + i * 76
        shapes += [
            rect(40, y, 110, 58, "0A1525", rx=8000),
            txBox(40, y+8, 110, 42,
                  para(run(label, bold=True, size=9, color=color), align="ctr")),
        ]
        for j, item in enumerate(items):
            bx = 166 + j * 148
            shapes += [
                rect(bx, y+8, 140, 42, "0A1525", rx=8000),
                txBox(bx+6, y+14, 128, 28, para(run(item, size=9, color="93C5FD"), align="ctr")),
            ]
    shapes += [
        rect(0, SLIDE_H-18, SLIDE_W, 18, "000D28"),
        txBox(20, SLIDE_H-16, 400, 14, para(run("🏦  Bharat AI Bank  ·  AgentX Innovators", size=7, color="506080"))),
        txBox(SLIDE_W-80, SLIDE_H-16, 70, 14, para(run("08 / 11", size=7, color="506080"), align="r")),
    ]
    return slide_xml(shapes)


def build_impact():
    impacts = [
        ("10b981", "⚡", "99% Faster Disputes",    "2 minutes vs 5–7 days"),
        ("D4A017", "🇮🇳", "700M+ Hindi Users",     "Full native Hindi support"),
        ("0057B8", "🤖", "100% Self-Service",       "Zero human agent needed"),
        ("7C3AED", "📄", "AI Doc Processing",       "Receipts extracted in 3 secs"),
        ("EF4444", "💰", "Zero Branch Visits",      "EMI restructuring from chat"),
        ("10b981", "🚀", "Production Ready",        "Real code, not a prototype"),
    ]
    shapes = [
        rect(0, 0, SLIDE_W, SLIDE_H, DARK),
        rect(0, 0, SLIDE_W, 4, GOLD),
        txBox(40, 22, 400, 16, para(run("WHY IT MATTERS", size=9, color=GOLD, bold=True))),
        txBox(40, 38, 700, 36, para(run("Business ", bold=True, size=26, color=WHITE) +
                                    run("Impact", bold=True, size=26, color=GOLD))),
    ]
    cw, ch = 278, 118
    for i, (color, icon, title, sub) in enumerate(impacts):
        col, row2 = i % 3, i // 3
        x = 40 + col * (cw + 20)
        y = 90 + row2 * (ch + 14)
        shapes += [
            rect(x, y, cw, ch, "0A1525", rx=10000),
            rect(x, y, cw, 4, color),
            txBox(x+12, y+12, cw-20, 36, para(run(f"{icon}  {title}", bold=True, size=14, color=WHITE))),
            txBox(x+12, y+48, cw-20, 28, para(run(sub, size=11, color="8090A0"))),
        ]
    shapes += [
        rect(0, SLIDE_H-18, SLIDE_W, 18, "000D28"),
        txBox(20, SLIDE_H-16, 400, 14, para(run("🏦  Bharat AI Bank  ·  AgentX Innovators", size=7, color="506080"))),
        txBox(SLIDE_W-80, SLIDE_H-16, 70, 14, para(run("09 / 11", size=7, color="506080"), align="r")),
    ]
    return slide_xml(shapes)


def build_roadmap():
    items = [
        ("🏦", "UPI / NEFT Transfers",      "Agent-initiated fund transfers via conversational commands"),
        ("🌐", "Regional Languages",         "Tamil, Telugu, Bengali, Marathi support coming next"),
        ("🎙️", "Voice Banking",             "Salesforce Voice integration for hands-free banking"),
        ("🚨", "Proactive Fraud Alerts",     "Real-time unusual transaction detection and notification"),
        ("📈", "Investment Advisory",        "AI-powered mutual fund recommendations via agent"),
        ("🏢", "Multi-Bank Support",         "Extend to other Indian banks with configurable personas"),
    ]
    shapes = [
        rect(0, 0, SLIDE_W, SLIDE_H, DARK),
        rect(0, 0, SLIDE_W, 4, GOLD),
        txBox(40, 22, 400, 16, para(run("WHAT'S NEXT", size=9, color=GOLD, bold=True))),
        txBox(40, 38, 700, 36, para(run("Roadmap & ", bold=True, size=26, color=WHITE) +
                                    run("Future Plans", bold=True, size=26, color=GOLD))),
    ]
    for i, (icon, title, desc) in enumerate(items):
        col, row2 = i % 2, i // 2
        x = 40  + col * 440
        y = 100 + row2 * 116
        shapes += [
            rect(x, y, 420, 100, "0A1525", rx=10000),
            rect(x, y, 4, 100, GOLD),
            txBox(x+18, y+14, 390, 28, para(run(f"{icon}  {title}", bold=True, size=13, color=WHITE))),
            txBox(x+18, y+42, 390, 44, para(run(desc, size=10, color="8090A0"))),
        ]
    shapes += [
        rect(0, SLIDE_H-18, SLIDE_W, 18, "000D28"),
        txBox(20, SLIDE_H-16, 400, 14, para(run("🏦  Bharat AI Bank  ·  AgentX Innovators", size=7, color="506080"))),
        txBox(SLIDE_W-80, SLIDE_H-16, 70, 14, para(run("10 / 11", size=7, color="506080"), align="r")),
    ]
    return slide_xml(shapes)


def build_thankyou():
    shapes = [
        rect(0, 0, SLIDE_W, SLIDE_H, NAVY),
        rect(0, 0, SLIDE_W, 6, GOLD),
        rect(0, SLIDE_H-6, SLIDE_W, 6, GOLD),
        circle(700, -80, 320, "0A3580"),
        circle(-80, 300, 240, "0A2560"),
        # Title
        txBox(50, 60, SLIDE_W-100, 70,
              para(run("Thank ", bold=True, size=48, color=WHITE) +
                   run("You!", bold=True, size=48, color=GOLD), align="ctr")),
        txBox(80, 138, SLIDE_W-160, 36,
              para(run("We built Bharat AI Bank to make banking accessible, intelligent,", size=13, color="A0C4FF"), align="ctr")),
        txBox(80, 162, SLIDE_W-160, 24,
              para(run("and instant for every Indian customer — in their own language.", size=13, color="A0C4FF"), align="ctr")),
        # GitHub link
        rect(307, 200, 300, 32, "0A3070", rx=16000),
        txBox(307, 200, 300, 32,
              para(run("💻  github.com/princy2806/Bharat-AI-Bank", size=10, color="93C5FD"), align="ctr")),
        # Team row
        txBox(80, 250, SLIDE_W-160, 16,
              para(run("TEAM  AGENTX  INNOVATORS", bold=True, size=9, color=GOLD), align="ctr")),
    ]
    # Team avatars
    members_final = [
        ("PS", BLUE,     "Princy Shah",    "Salesforce Tech Lead"),
        ("SD", "C07D10", "Shraddha Dere",  "Salesforce Tech Lead"),
        ("AO", "5B21B6", "Ankur Omar",     "Salesforce Manager"),
        ("RK", "065F46", "Ravi Kamal",     "Salesforce Tech Lead"),
    ]
    total_w = 4 * 90 + 3 * 40
    start_x = (SLIDE_W - total_w) / 2
    for i, (init, color, name, role) in enumerate(members_final):
        ax = start_x + i * 130
        shapes += [
            circle(ax, 274, 72, color),
            txBox(ax, 282, 72, 40, para(run(init, bold=True, size=20, color=WHITE), align="ctr")),
            txBox(ax-18, 352, 108, 18, para(run(name, bold=True, size=10, color=WHITE), align="ctr")),
            txBox(ax-18, 368, 108, 16, para(run(role, size=8.5, color="607080"), align="ctr")),
        ]
    shapes += [
        txBox(80, 400, SLIDE_W-160, 20,
              para(run("Agentforce Hackathon 2026  ·  Built with Salesforce Agentforce + Einstein Document AI", size=9, color="506080"), align="ctr")),
        txBox(SLIDE_W-80, SLIDE_H-24, 70, 14,
              para(run("11 / 11", size=7, color="506080"), align="r")),
    ]
    return slide_xml(shapes)


# ── BOILERPLATE XML ───────────────────────────────────────────────
PRESENTATION_XML = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  saveSubsetFonts="1">
  <p:sldMasterIdLst><p:sldMasterId id="2147483648" r:id="rId1"/></p:sldMasterIdLst>
  <p:sldIdLst>
    <p:sldId id="256" r:id="rId2"/>
    <p:sldId id="257" r:id="rId3"/>
    <p:sldId id="258" r:id="rId4"/>
    <p:sldId id="259" r:id="rId5"/>
    <p:sldId id="260" r:id="rId6"/>
    <p:sldId id="261" r:id="rId7"/>
    <p:sldId id="262" r:id="rId8"/>
    <p:sldId id="263" r:id="rId9"/>
    <p:sldId id="264" r:id="rId10"/>
    <p:sldId id="265" r:id="rId11"/>
    <p:sldId id="266" r:id="rId12"/>
  </p:sldIdLst>
  <p:sldSz cx="11887200" cy="6686550"/>
  <p:notesSz cx="6858000" cy="9144000"/>
</p:presentation>"""

PRES_RELS = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster1.xml"/>
  <Relationship Id="rId2"  Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide1.xml"/>
  <Relationship Id="rId3"  Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide2.xml"/>
  <Relationship Id="rId4"  Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide3.xml"/>
  <Relationship Id="rId5"  Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide4.xml"/>
  <Relationship Id="rId6"  Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide5.xml"/>
  <Relationship Id="rId7"  Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide6.xml"/>
  <Relationship Id="rId8"  Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide7.xml"/>
  <Relationship Id="rId9"  Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide8.xml"/>
  <Relationship Id="rId10" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide9.xml"/>
  <Relationship Id="rId11" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide10.xml"/>
  <Relationship Id="rId12" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide11.xml"/>
</Relationships>"""

SLIDE_REL = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
</Relationships>"""

CONTENT_TYPES = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml"  ContentType="application/xml"/>
  <Override PartName="/ppt/presentation.xml"
    ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>
  <Override PartName="/ppt/slideMasters/slideMaster1.xml"
    ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/>
  <Override PartName="/ppt/slideLayouts/slideLayout1.xml"
    ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>
""" + "".join(
    f'  <Override PartName="/ppt/slides/slide{i}.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>\n'
    for i in range(1, 12)
) + "</Types>"

ROOT_RELS = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>
</Relationships>"""

SLIDE_MASTER = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <p:cSld><p:spTree>
    <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
    <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>
      <a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
  </p:spTree></p:cSld>
  <p:clrMap bg1="lt1" tx1="dk1" bg2="lt2" tx2="dk2" accent1="accent1"
    accent2="accent2" accent3="accent3" accent4="accent4"
    accent5="accent5" accent6="accent6" hlink="hlink" folHlink="folHlink"/>
  <p:sldLayoutIdLst><p:sldLayoutId id="2147483649" r:id="rId1"/></p:sldLayoutIdLst>
</p:sldMaster>"""

SLIDE_MASTER_REL = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
</Relationships>"""

SLIDE_LAYOUT = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  type="blank" preserve="1">
  <p:cSld><p:spTree>
    <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
    <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>
      <a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
  </p:spTree></p:cSld>
  <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
</p:sldLayout>"""

SLIDE_LAYOUT_REL = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster1.xml"/>
</Relationships>"""

# ── BUILD SLIDES ─────────────────────────────────────────────────
slides = [
    build_cover(),
    build_team_overview(),
    build_member_slide(TEAM[0], 1),   # Princy
    build_member_slide(TEAM[1], 2),   # Shraddha
    build_member_slide(TEAM[2], 3),   # Ankur
    build_member_slide(TEAM[3], 4),   # Ravi
    build_project_highlights(),
    build_tech_stack(),
    build_impact(),
    build_roadmap(),
    build_thankyou(),
]

# ── WRITE PPTX ───────────────────────────────────────────────────
with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
    z.writestr("[Content_Types].xml", CONTENT_TYPES)
    z.writestr("_rels/.rels", ROOT_RELS)
    z.writestr("ppt/presentation.xml", PRESENTATION_XML)
    z.writestr("ppt/_rels/presentation.xml.rels", PRES_RELS)
    z.writestr("ppt/slideMasters/slideMaster1.xml", SLIDE_MASTER)
    z.writestr("ppt/slideMasters/_rels/slideMaster1.xml.rels", SLIDE_MASTER_REL)
    z.writestr("ppt/slideLayouts/slideLayout1.xml", SLIDE_LAYOUT)
    z.writestr("ppt/slideLayouts/_rels/slideLayout1.xml.rels", SLIDE_LAYOUT_REL)
    for i, s in enumerate(slides, 1):
        z.writestr(f"ppt/slides/slide{i}.xml", s)
        z.writestr(f"ppt/slides/_rels/slide{i}.xml.rels", SLIDE_REL)

print(f"✅ PPT created: {OUT}")
print(f"   Slides: {len(slides)}")
print(f"   Size:   {OUT.stat().st_size // 1024} KB")
