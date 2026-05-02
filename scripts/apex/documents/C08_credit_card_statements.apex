// C08: Credit Card Statements (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: CREDIT_CARD_STATEMENT
// Fields: Card Number, Credit Limit, Outstanding, Due Date, Transactions

class U {
    static String p(Integer n){String s=String.valueOf(n);while(s.length()<10)s='0'+s;return s;}
    static String e(String s){return s==null?'':s.replace('\\','\\\\').replace('(','\\(').replace(')','\\)');}
    static Blob pdf(List<String> L){
        String st='BT /F1 9 Tf 20 820 Td 12 TL\n';
        for(String l:L)st+='('+e(l.left(85))+') Tj T*\n';
        st+='ET';
        String h='%PDF-1.4\n',
            o1='1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n',
            o2='2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n',
            o3='3 0 obj<</Type/Page/MediaBox[0 0 595 842]/Parent 2 0 R/Contents 4 0 R/Resources<</Font<</F1<</Type/Font/Subtype/Type1/BaseFont/Courier>>>>>>endobj\n',
            o4='4 0 obj<</Length '+st.length()+'>>\nstream\n'+st+'\nendstream\nendobj\n';
        Integer p1=h.length(),p2=p1+o1.length(),p3=p2+o2.length(),p4=p3+o3.length(),px=p4+o4.length();
        String xr='xref\n0 5\n0000000000 65535 f \n'+p(p1)+' 00000 n \n'+p(p2)+' 00000 n \n'+p(p3)+' 00000 n \n'+p(p4)+' 00000 n \n';
        return Blob.valueOf(h+o1+o2+o3+o4+xr+'trailer<</Size 5/Root 1 0 R>>\nstartxref\n'+px+'\n%%EOF');
    }
    static String cardBank(Integer idx){
        List<String> banks=new List<String>{'HDFC Bank','ICICI Bank','SBI Card','Axis Bank',
            'Kotak Mahindra Bank','American Express','Citibank','Standard Chartered'};
        return banks[Math.mod(idx,8)];
    }
    static String cardType(Integer idx){
        List<String> types=new List<String>{'Regalia Gold','Millennia','SimplySAVE',
            'My Zone','Platinum','Gold Charge','Cashback','Manhattan Platinum'};
        return types[Math.mod(idx,8)];
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,BillingCity,AnnualRevenue FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String bk=U.cardBank(cnt);
    String ct=U.cardType(cnt);
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:500000;
    Integer limit=(Integer)(Math.min(500000,Math.max(50000,(Integer)(rev/10))));
    limit=Math.round(limit/10000)*10000;
    Integer outstanding=Math.mod(hv,limit/2);
    outstanding=Math.round(outstanding/100)*100;
    Integer minDue=(Integer)(outstanding*0.05);
    String cardNum='XXXX XXXX XXXX '+String.valueOf(1000+Math.mod(hv,9000));
    String statDate=String.valueOf(Date.today().addDays(-5));
    String dueDate=String.valueOf(Date.today().addDays(15));
    List<String> lines=new List<String>{
        bk.toUpperCase()+' CREDIT CARD',
        ct.toUpperCase()+' - MONTHLY STATEMENT',
        '================================================================',
        'Card Number      : '+cardNum,
        'Card Holder      : '+nm,
        'Statement Period : '+String.valueOf(Date.today().addDays(-35))+' to '+statDate,
        'Payment Due Date : '+dueDate,
        '================================================================',
        'ACCOUNT SUMMARY:',
        'Credit Limit     : Rs '+String.valueOf(limit),
        'Available Credit : Rs '+String.valueOf(limit-outstanding),
        'Total Outstanding: Rs '+String.valueOf(outstanding),
        'Minimum Amount Due: Rs '+String.valueOf(minDue),
        '================================================================',
        'TRANSACTION DETAILS (Mar 2026):',
        '2026-03-02  Amazon Online Shopping         Rs 3,450',
        '2026-03-05  Petrol Pump                    Rs 2,500',
        '2026-03-08  Swiggy Food Delivery            Rs 1,200',
        '2026-03-12  Medical Pharmacy               Rs 850',
        '2026-03-15  Utility Bill Payment            Rs 2,100',
        '2026-03-18  Grocery - Big Bazaar           Rs 4,300',
        '2026-03-22  Restaurant Dining              Rs 1,800',
        '2026-03-25  OTT Subscription               Rs 499',
        '================================================================',
        'REWARDS POINTS: '+String.valueOf(Math.mod(hv,5000)+500)+' points (Rs '+String.valueOf(Math.mod(hv,500)+50)+' value)',
        'CASHBACK THIS MONTH: Rs '+String.valueOf(Math.mod(hv,300)+50),
        '================================================================',
        'Interest Rate    : 3.75% per month (45% p.a.)',
        'Payment Options  : NetBanking | UPI | NEFT | Cheque',
        'Customer Care    : 1800-XXX-XXXX | '+bk.toLowerCase().replace(' ','')+'.com'
    };
    batch.add(new ContentVersion(
        Title='Credit Card Statement - '+a.FirstName+' '+a.LastName+' (Mar 2026)',
        PathOnClient='CreditCard_'+a.FirstName+'_'+a.LastName+'_Mar2026.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Credit card statements inserted: '+cnt);
