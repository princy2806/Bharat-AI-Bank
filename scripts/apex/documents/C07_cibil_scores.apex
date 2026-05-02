// C07: CIBIL Credit Score Reports (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: CIBIL_REPORT
// Fields: Score, Payment History, Credit Utilization, Loan Accounts, Enquiries

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
    static Integer score(Integer hv, Decimal churn){
        // Higher churn risk = lower score
        Integer base=750;
        if(churn!=null){
            if(churn>80)base=580+Math.mod(hv,70);
            else if(churn>60)base=640+Math.mod(hv,60);
            else if(churn>40)base=700+Math.mod(hv,50);
            else base=760+Math.mod(hv,60);
        } else base=720+Math.mod(hv,80);
        return Math.min(900,Math.max(300,base));
    }
    static String rating(Integer sc){
        if(sc>=800)return 'EXCELLENT';
        if(sc>=750)return 'VERY GOOD';
        if(sc>=700)return 'GOOD';
        if(sc>=650)return 'FAIR';
        return 'POOR';
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,PersonBirthdate,BillingCity,AnnualRevenue,ChurnRiskScore__pc FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    Decimal churn=a.ChurnRiskScore__pc;
    Integer sc=U.score(hv,churn);
    String rating=U.rating(sc);
    String city=a.BillingCity!=null?a.BillingCity:'';
    Integer util=20+Math.mod(hv,50);
    Integer activeLoans=Math.mod(hv,4)+1;
    Integer closedLoans=Math.mod(hv,3);
    Integer enquiries=Math.mod(hv,5);
    String pan='XXXXX'+String.valueOf(1000+cnt)+'X';
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:500000;
    List<String> lines=new List<String>{
        'TRANSUNION CIBIL LIMITED',
        'CREDIT INFORMATION REPORT (CIR)',
        '================================================================',
        'Report Date      : '+String.valueOf(Date.today()),
        'Report Type      : Consumer CIR',
        'Report Ref No    : CIR/'+String.valueOf(Date.today().year())+'/'+String.valueOf(hv).left(8),
        '================================================================',
        'CONSUMER DETAILS:',
        'Full Name        : '+nm,
        'Date of Birth    : '+(a.PersonBirthdate!=null?String.valueOf(a.PersonBirthdate):'1985-01-15'),
        'PAN              : '+pan,
        'Address          : '+city,
        '================================================================',
        'CIBIL SCORE      : '+String.valueOf(sc)+' / 900',
        'Rating           : '+rating,
        'Score Change     : +'+String.valueOf(Math.mod(hv,25))+' (vs last quarter)',
        '================================================================',
        'CREDIT SUMMARY:',
        'Active Accounts  : '+String.valueOf(activeLoans),
        'Closed Accounts  : '+String.valueOf(closedLoans),
        'Total Accounts   : '+String.valueOf(activeLoans+closedLoans),
        'Recent Enquiries : '+String.valueOf(enquiries)+' (last 6 months)',
        '================================================================',
        'PAYMENT HISTORY  : '+(sc>=750?'EXCELLENT - No defaults':'FAIR - Minor delays'),
        'CREDIT UTILIZATION: '+String.valueOf(util)+'% of limit used',
        'CREDIT AGE       : '+String.valueOf(3+Math.mod(hv,12))+' years (avg)',
        'CREDIT MIX       : Home Loan, Credit Card'+(activeLoans>2?', Personal Loan':''),
        '================================================================',
        'This report is valid for 30 days from report date.',
        'Dispute: www.cibil.com | 022-6140-4300'
    };
    batch.add(new ContentVersion(
        Title='CIBIL Score Report - '+a.FirstName+' '+a.LastName,
        PathOnClient='CIBIL_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('CIBIL reports inserted: '+cnt);
