// C21: Mutual Fund CAS Statements (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: MUTUAL_FUND_STATEMENT
// Fields: Folio, Fund Name, Units, NAV, Current Value, SIP, XIRR

class U {
    String p(Integer n){String s=String.valueOf(n);while(s.length()<10)s='0'+s;return s;}
    String e(String s){return s==null?'':s.replace('\\','\\\\').replace('(','\\(').replace(')','\\)');}
    Blob pdf(List<String> L){
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
    String fund(Integer idx){
        List<String> funds=new List<String>{
            'AXIS BLUECHIP FUND - Growth Plan',
            'HDFC FLEXI CAP FUND - Growth Plan',
            'MIRAE ASSET LARGE CAP FUND - Growth Plan',
            'ICICI PRU BALANCED ADVANTAGE FUND - Growth',
            'SBI SMALL CAP FUND - Growth Plan',
            'KOTAK EMERGING EQUITY FUND - Growth',
            'PARAG PARIKH FLEXI CAP FUND - Growth',
            'NIPPON INDIA GROWTH FUND - Growth Plan',
            'DSP MIDCAP FUND - Growth Plan',
            'ADITYA BIRLA SL FRONTLINE EQUITY - Growth'
        };
        return funds[Math.mod(idx,10)];
    }
    String amc(Integer idx){
        List<String> amcs=new List<String>{'Axis AMC','HDFC AMC','Mirae Asset',
            'ICICI Prudential','SBI Funds','Kotak AMC','PPFAS AMC','Nippon India',
            'DSP Investment','Aditya Birla SL'};
        return amcs[Math.mod(idx,10)];
    }
    String registrar(Integer idx){
        return Math.mod(idx,2)==0?'CAMS (Computer Age Management Services)':'KFintech (KFin Technologies)';
    }
    String folio(String amc, Integer idx){
        String a2=amc.left(4).toUpperCase().replace(' ','');
        return a2+'/'+String.valueOf(1000000+Math.mod(idx*7,8999999))+'/01';
    }
}

U u=new U();
List<Account> accs=[SELECT Id,FirstName,LastName,BillingCity,AnnualRevenue FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:600000;
    String fundName=u.fund(cnt);
    String amcName=u.amc(cnt);
    String reg=u.registrar(cnt);
    String folioNo=u.folio(amcName,hv);
    Integer monthly=(Integer)(rev/12);
    Integer sipAmt=Math.round(Math.min(20000,Math.max(1000,monthly*0.1))/500)*500;
    Integer sipMonths=12+Math.mod(hv,60);
    Integer invested=sipAmt*sipMonths;
    Decimal xirr=12.0+Math.mod(hv,8);
    Decimal nav=100+Math.mod(hv,300);
    Decimal growth=1+xirr/100*sipMonths/12;
    Integer currentVal=(Integer)(invested*growth*0.8+invested*0.2); // simplified
    Integer units=(Integer)(currentVal/nav);
    Integer sipDate=1+Math.mod(hv,27);
    // ELSS second folio
    String fund2=''+amcName.left(4).toUpperCase()+' ELSS TAX SAVER - Growth';
    Integer elssInvested=Math.min(150000,sipAmt*6*12);
    Decimal elssNav=50+Math.mod(hv,150);
    Integer elssUnits=(Integer)(elssInvested*1.15/elssNav);
    Integer elssVal=(Integer)(elssUnits*elssNav);
    List<String> lines=new List<String>{
        'CONSOLIDATED ACCOUNT STATEMENT (CAS)',
        reg,
        '================================================================',
        'Statement Period : 01-Apr-2020 to 31-Mar-2026',
        'Investor Name    : '+nm,
        'PAN              : XXXXX'+String.valueOf(1000+cnt)+'X',
        'City             : '+city,
        '================================================================',
        'FOLIO 1: '+folioNo,
        'AMC              : '+amcName,
        'Fund Name        : '+fundName,
        'Category         : Equity | Riskometer: Moderately High',
        '================================================================',
        'PORTFOLIO SUMMARY:',
        'Total Months of SIP  : '+String.valueOf(sipMonths)+' months',
        'Total Amount Invested: Rs '+String.valueOf(invested),
        'Total Units Held     : '+String.valueOf(units)+'.'+String.valueOf(Math.mod(hv,999)),
        'Current NAV (Mar-26) : Rs '+String.valueOf((Integer)nav)+'.'+String.valueOf(Math.mod(hv,99)),
        'Current Value        : Rs '+String.valueOf(currentVal),
        'Unrealised Gain      : Rs '+String.valueOf(currentVal-invested),
        'XIRR Return          : '+String.valueOf((Integer)xirr)+'.'+String.valueOf(Math.mod(hv,9))+'% p.a.',
        '================================================================',
        'SIP MANDATE:',
        'SIP Amount       : Rs '+String.valueOf(sipAmt)+' per month',
        'SIP Date         : '+String.valueOf(sipDate)+'th of each month',
        'Status           : ACTIVE | Next SIP: '+String.valueOf(sipDate)+'-May-2026',
        '================================================================',
        'FOLIO 2 (ELSS - 80C Benefit):',
        'Fund             : '+fund2,
        'Total Invested   : Rs '+String.valueOf(elssInvested),
        'Units Held       : '+String.valueOf(elssUnits),
        'Current Value    : Rs '+String.valueOf(elssVal),
        'Lock-in Status   : 3-year lock-in (batch-wise)',
        '================================================================',
        'TOTAL PORTFOLIO VALUE: Rs '+String.valueOf(currentVal+elssVal),
        'REDEMPTION BANK  : Account linked (IFSC Verified)',
        'Platform         : '+reg.left(4)+' | www.camsonline.com | 1800-200-2267'
    };
    batch.add(new ContentVersion(
        Title='Mutual Fund Statement - '+a.FirstName+' '+a.LastName+' (Mar 2026)',
        PathOnClient='MF_Statement_'+a.FirstName+'_'+a.LastName+'_Mar2026.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=u.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Mutual fund statements inserted: '+cnt);
