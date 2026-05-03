# BHARAT AI BANK - TEST SCENARIOS
## Customer: Rajesh Sharma
### Email: rajesh.sharma@yopmail.com
### Mix: Hindi + English

---

## SCENARIO 1 — Account Balance & Statement Check

### Customer: Rajesh Sharma
### Use Case: Check account balance and view recent statement
### Duration: 2-3 minutes

---

### Opening Chat

**Rajesh:** "नमस्ते! मैं अपना खाता बैलेंस चेक करना चाहता हूँ।"
*(Hello! I want to check my account balance.)*

**Agent:** "नमस्ते Rajesh! आपका स्वागत है Bharat AI Bank में। मैं आपकी मदद करके खुश हूँ। आपके खाते की जानकारी एक सेकंड में मिलेगी।"
*(Hello Rajesh! Welcome to Bharat AI Bank. I'm happy to help. Your account information will be ready in a second.)*

[PAUSE - Agent fetches data from core banking system - 2 seconds]

**Agent:** "आपका Current Account Balance: ₹97,650
Available Balance: ₹97,650
Last Transaction: ₹5,000 Transfer - Yesterday at 3:45 PM

क्या आप अपना पूरा statement भी देखना चाहते हैं?"

*(Your Current Account Balance: ₹97,650
Available Balance: ₹97,650
Last Transaction: ₹5,000 Transfer - Yesterday at 3:45 PM

Would you also like to see your full statement?)*

---

### Rajesh Requests Statement

**Rajesh:** "हाँ, मुझे पिछले 30 दिनों का statement भेज दो।"
*(Yes, send me the last 30 days statement.)*

**Agent:** "बिल्कुल! आपका statement तैयार है। यहाँ आपके पिछले 30 दिनों के transactions हैं:

📅 **Last 30 Days Summary:**
- Total Credit: ₹50,000 (2 transactions)
- Total Debit: ₹35,500 (5 transactions)
- Opening Balance: ₹82,150
- Closing Balance: ₹97,650

क्या आप किसी specific transaction के बारे में पूछना चाहते हैं?"

*(Perfect! Your statement is ready. Here are your transactions from the last 30 days:

📅 **Last 30 Days Summary:**
- Total Credit: ₹50,000 (2 transactions)
- Total Debit: ₹35,500 (5 transactions)
- Opening Balance: ₹82,150
- Closing Balance: ₹97,650

Would you like to ask about any specific transaction?)*

---

### Download Statement

**Rajesh:** "Statement को PDF mein download kar do, mujhe email kar dena।"
*(Download the statement as PDF and email it to me.)*

**Agent:** "बिल्कुल! आपका statement PDF तैयार हो गया है। मैं इसे आपके email rajesh.sharma@yopmail.com पर भेज रहा हूँ।"

[SHOW: Email sending confirmation]

"✅ Statement successfully emailed to rajesh.sharma@yopmail.com

आप अपना statement अभी download भी कर सकते हैं या later देख सकते हैं।"

*(Perfect! Your statement PDF is ready. I'm sending it to your email rajesh.sharma@yopmail.com.

✅ Statement successfully emailed to rajesh.sharma@yopmail.com

You can download your statement now or view it later.)*

---

**[END SCENARIO 1 - 2-3 minutes]**

---

## SCENARIO 2 — Credit Card Dispute Testing

### Customer: Rajesh Sharma
### Use Case: File a dispute for unauthorized transaction
### Amount: ₹5,999
### Duration: 3-4 minutes

---

### Initiate Dispute

**Rajesh:** "I want to dispute a credit card transaction।"

**Agent:** "नमस्ते! Dispute के लिए धन्यवाद contact करने के लिए। मैं आपकी मदद कर सकता हूँ।

कृपया बताएं: किस amount को dispute करना है?"

*(Hello! Thank you for contacting us about a dispute. I can help you.

Please tell me: What amount do you want to dispute?)*

---

### Provide Transaction Details

**Rajesh:** "I didn't make this ₹5,999 charge. It looks like an unauthorized international transaction।"

**Agent:** "समझ गया। यह एक unauthorized transaction है। बिल्कुल चिंता मत करो।

[SHOW: Agent asks for receipt/statement]

कृपया अपना credit card statement या receipt upload करो। Document AI इसे verify करेगा।"

*(Understood. This is an unauthorized transaction. Don't worry at all.

[SHOW: Agent asks for receipt/statement]

Please upload your credit card statement or receipt. Document AI will verify it.)*

---

### Upload Document

**Rajesh:** [Uploads credit card statement PDF showing the ₹5,999 charge]

[PAUSE - Document AI processes - 3 seconds]

**Agent:** "✅ Document received और analyzed!

मैंने आपके statement से निम्नलिखित details extract किए हैं:

💳 **Dispute Details:**
- Transaction Amount: ₹5,999
- Merchant: Amazon Global (International)
- Transaction Date: May 1, 2025
- Status: UNAUTHORIZED

[SHOW: Salesforce Case Created]

मैं अभी एक HIGH PRIORITY fraud case बनाता हूँ:"

*(✅ Document received and analyzed!

I've extracted the following details from your statement:

💳 **Dispute Details:**
- Transaction Amount: ₹5,999
- Merchant: Amazon Global (International)
- Transaction Date: May 1, 2025
- Status: UNAUTHORIZED

[SHOW: Salesforce Case Created]

I'm creating a HIGH PRIORITY fraud case now:)*

---

### Case Confirmation

**Agent:** "✅ **Dispute Case Created Successfully!**

📋 Case Number: #DIS-2025-00845
🔴 Priority: HIGH (Fraud)
⏱️ Expected Resolution: 3-5 Business Days
📧 Confirmation sent to: rajesh.sharma@yopmail.com

आपके case को हमारे fraud investigation team को assign कर दिया गया है। वे 24 घंटे में contact करेंगे।

क्या मैं कुछ और कर सकता हूँ?"

*(✅ **Dispute Case Created Successfully!**

📋 Case Number: #DIS-2025-00845
🔴 Priority: HIGH (Fraud)
⏱️ Expected Resolution: 3-5 Business Days
📧 Confirmation sent to: rajesh.sharma@yopmail.com

Your case has been assigned to our fraud investigation team. They will contact you within 24 hours.

Is there anything else I can help with?)*

---

### Real-time Tracking

**Rajesh:** "मुझे case track करना है। Status kaise check karunga?"
*(I want to track the case. How can I check the status?)*

**Agent:** "बिल्कुल! आप यहाँ अपना case track कर सकते हो:

🔗 **Case Tracking Link:**
https://bharat-aibank.salesforce.com/cases/DIS-2025-00845

या बस इस chat में मुझसे पूछ सकते हो: 'Case का status क्या है?'

मैं आपको real-time update दूंगा।"

*(Perfect! You can track your case here:

🔗 **Case Tracking Link:**
https://bharat-aibank.salesforce.com/cases/DIS-2025-00845

Or you can just ask me in this chat: 'What's my case status?'

I'll give you real-time updates.)*

---

**[END SCENARIO 2 - 3-4 minutes]**

---

## SCENARIO 3 — EMI Restructuring Testing

### Customer: Rajesh Sharma
### Use Case: Home loan EMI restructuring due to family emergency
### Duration: 4-5 minutes

---

### Initial Request

**Rajesh:** "I'm going through a family emergency and I need to reduce my home loan EMI।"

**Agent:** "समझ गया, Rajesh। यह मुश्किल समय है। Home loan EMI reduce करने के कई options हैं।

कृपया कुछ seconds wait करो जबकि मैं आपका loan account details fetch करता हूँ।"

*(Understood, Rajesh. This is a difficult time. There are several options to reduce your home loan EMI.

Please wait a few seconds while I fetch your loan account details.)*

[PAUSE - Fetching loan data - 3 seconds]

---

### Loan Details & Options

**Agent:** "✅ आपकी loan जानकारी:

🏠 **Home Loan Account Details:**
- Loan Amount: ₹25,00,000
- Current EMI: ₹25,000/month
- Tenure: 15 years (180 months)
- Remaining Tenure: 120 months (10 years)
- Current Rate: 7.5% per annum

**आपके 3 Options हैं:**

**Option A: EMI Reduction via Tenure Extension**
- नया EMI: ₹18,500/month (26% कम)
- नया Tenure: 18 years (216 months)
- Extra Interest: ₹2,15,000

**Option B: Loan Restructuring (Balance Transfer)**
- नया EMI: ₹21,000/month (16% कम)
- Same Tenure: 10 years remaining
- Better Interest Rate: 7.2%

**Option C: Payment Holiday (6 months)**
- No EMI for next 6 months
- Resume after 6 months with adjusted amount
- Manageable for short-term crisis

कौन सा option अच्छा लगता है?"

*(✅ Here are your loan details:

🏠 **Home Loan Account Details:**
- Loan Amount: ₹25,00,000
- Current EMI: ₹25,000/month
- Tenure: 15 years (180 months)
- Remaining Tenure: 120 months (10 years)
- Current Rate: 7.5% per annum

**You have 3 Options:**

**Option A: EMI Reduction via Tenure Extension**
- New EMI: ₹18,500/month (26% reduction)
- New Tenure: 18 years (216 months)
- Extra Interest: ₹2,15,000

**Option B: Loan Restructuring (Balance Transfer)**
- New EMI: ₹21,000/month (16% reduction)
- Same Tenure: 10 years remaining
- Better Interest Rate: 7.2%

**Option C: Payment Holiday (6 months)**
- No EMI for next 6 months
- Resume after 6 months with adjusted amount
- Manageable for short-term crisis

Which option looks good?)*

---

### Select Option & Request RM Callback

**Rajesh:** "Option A looks good. Can you also schedule a callback with my RM?"
*(Option A ठीक लग रहा है। मेरे RM के साथ callback schedule कर सकते हो?)*

**Agent:** "बिल्कुल! Option A process करने जा रहा हूँ और आपके Relationship Manager को callback schedule कर दूंगा।

आपके RM का नाम: Ms. Priya Verma

उन्हें कब callback दिलवाना है?"

*(Perfect! I'll process Option A and schedule a callback with your Relationship Manager.

Your RM's name: Ms. Priya Verma

When should I schedule the callback?)*

---

### Schedule Callback

**Rajesh:** "Tomorrow between 10 AM and 12 PM please।"

**Agent:** "बिल्कुल! Callback scheduled कर दिया गया है।

📞 **Callback Scheduled:**
- RM: Ms. Priya Verma
- Date: Tomorrow (May 4, 2025)
- Time Slot: 10:00 AM - 12:00 PM
- Phone: +91-XXXX-XXX-XXXX (आपका registered number)
- Topic: Home Loan EMI Restructuring (Option A)

[SHOW: Confirmation sent to email]

✅ Confirmation email भेज दी गई है rajesh.sharma@yopmail.com को।

आपका RM Ms. Priya Verma आपको कल इसी time slot में call करेंगी।"

*(Perfect! Callback has been scheduled.

📞 **Callback Scheduled:**
- RM: Ms. Priya Verma
- Date: Tomorrow (May 4, 2025)
- Time Slot: 10:00 AM - 12:00 PM
- Phone: +91-XXXX-XXX-XXXX (your registered number)
- Topic: Home Loan EMI Restructuring (Option A)

[SHOW: Confirmation sent to email]

✅ Confirmation email has been sent to rajesh.sharma@yopmail.com.

Your RM Ms. Priya Verma will call you tomorrow during this time slot.)*

---

### Additional Support

**Agent:** "Rajesh, एक बात और। तुम्हारे financial crisis के लिए कुछ और options भी हैं:

💰 **अन्य Support Options:**
1. **Personal Loan** - Quick approval (24 hours)
2. **Credit Line** - Emergency funds access
3. **Balance Transfer** - Lower interest rate
4. **Investment Portfolio Review** - दूसरी income source देखेंगे

क्या तुम्हें इनमें से कोई चाहिए?"

*(Rajesh, one more thing. We also have other options for your financial crisis:

💰 **Other Support Options:**
1. **Personal Loan** - Quick approval (24 hours)
2. **Credit Line** - Emergency funds access
3. **Balance Transfer** - Lower interest rate
4. **Investment Portfolio Review** - Let's check other income sources

Do you need any of these?)*

---

### Close

**Rajesh:** "नहीं, अभी ये सब ठीक है। बस EMI reduce हो जाए तो काफी है।"
*(No, that's okay for now. Just reducing the EMI will be enough.)*

**Agent:** "समझ गया, Rajesh। मैं आपकी मदद कर सकूँ तो खुश हूँ।

**Summary:**
✅ Option A for EMI Reduction approved
✅ Callback scheduled with Ms. Priya Verma tomorrow 10-12 PM
✅ Documents sent to your email
✅ Case Reference: #RESTRUCTURE-2025-5847

कोई और सवाल? मैं always यहाँ हूँ।"

*(Understood, Rajesh. I'm happy to help.

**Summary:**
✅ Option A for EMI Reduction approved
✅ Callback scheduled with Ms. Priya Verma tomorrow 10-12 PM
✅ Documents sent to your email
✅ Case Reference: #RESTRUCTURE-2025-5847

Any other questions? I'm always here.)*

---

**[END SCENARIO 3 - 4-5 minutes]**

---

## SUMMARY OF ALL THREE SCENARIOS

| Scenario | Duration | Key Features Shown |
|----------|----------|-------------------|
| Scenario 1: Balance & Statement | 2-3 min | Real-time balance, statement generation, email delivery |
| Scenario 2: Credit Card Dispute | 3-4 min | Document AI, case creation, fraud priority, real-time tracking |
| Scenario 3: EMI Restructuring | 4-5 min | Loan details, multiple options, callback scheduling, support options |

---

## TIPS FOR DEMO

✅ **Use natural Hindi-English mix** — Just as Indians speak naturally  
✅ **Pause for processing** — Show agent is "thinking" and fetching data  
✅ **Highlight screen updates** — Let viewers see Salesforce, emails, etc.  
✅ **Show confirmations** — Case numbers, email confirmations, etc.  
✅ **Emphasize automation** — No manual work, Document AI speed, etc.  
✅ **Show emotion** — Agent empathy during family emergency scenario  

---

**Perfect for your demo! All scenarios ready with Rajesh! 🎬**

**— Team AgentX Innovators**
