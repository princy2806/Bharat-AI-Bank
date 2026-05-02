// C22: Property Valuation Reports (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: HOME_LOAN_PROPERTY_DOC
// Fields: Property Address, Market Value, Loan Recommended, Valuer, EC Status

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
    String valuer(String city){
        Map<String,String> vm=new Map<String,String>{
            'Indore'=>'Sharma & Associates Valuers','Mumbai'=>'Mumbai Property Valuers LLP',
            'Delhi'=>'Delhi Capital Valuers','Jaipur'=>'Rajasthan Valuers & Associates',
            'Pune'=>'Pune Valuers Associates','Bengaluru'=>'Karnataka Property Valuers',
            'Ahmedabad'=>'Gujarat Valuers Network','Hyderabad'=>'Deccan Property Experts',
            'Chennai'=>'TN Registered Valuers Assoc','Kolkata'=>'Bengal Property Valuers'
        };
        return vm.containsKey(city)?vm.get(city):city+' Certified Valuers';
    }
    String propType(Integer idx){
        List<String> pt=new List<String>{'Residential Apartment (2BHK)','Residential Apartment (3BHK)',
            'Independent House (3BHK)','Commercial Shop','Residential Plot',
            'Residential Apartment (1BHK)','Villa (4BHK)','Row House (3BHK)'};
        return pt[Math.mod(idx,8)];
    }
    String stateCode(String state){
        Map<String,String> sc=new Map<String,String>{
            'Madhya Pradesh'=>'MP','Maharashtra'=>'MH','Delhi'=>'DL','Rajasthan'=>'RJ',
            'Karnataka'=>'KA','Gujarat'=>'GJ','Telangana'=>'TL','Tamil Nadu'=>'TN',
            'West Bengal'=>'WB','Uttar Pradesh'=>'UP'
        };
        return sc.containsKey(state)?sc.get(state):'IN';
    }
}

U u=new U();
List<Account> accs=[SELECT Id,FirstName,LastName,BillingStreet,BillingCity,BillingState,BillingPostalCode,AnnualRevenue FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    String st2=a.BillingState!=null?a.BillingState:'';
    String pin=a.BillingPostalCode!=null?a.BillingPostalCode:'';
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:600000;
    String vlr=u.valuer(city);
    String pt=u.propType(cnt);
    String stCode=u.stateCode(st2);
    Integer marketVal=1500000+Math.mod(hv,13500000);
    marketVal=Math.round(marketVal/100000)*100000;
    Integer distressVal=Math.round(marketVal*0.8/100000)*100000;
    Integer loanRec=Math.round(marketVal*0.75/100000)*100000;
    Integer carpetArea=500+Math.mod(hv,1500);
    Integer sba=Math.round(carpetArea*1.25);
    Integer floorNo=Math.mod(hv,20)+1;
    String rptDate=String.valueOf(Date.today().addMonths(-(1+Math.mod(hv,12))));
    String validTill=String.valueOf(Date.valueOf(rptDate).addMonths(3));
    List<String> lines=new List<String>{
        'PROPERTY VALUATION REPORT',
        'Empanelled Valuer: '+vlr,
        'Registration No  : IBI-'+String.valueOf(Date.today().year()-Math.mod(hv,5))+'-'+stCode+'-'+String.valueOf(100+Math.mod(hv,899)),
        '================================================================',
        'Report Date      : '+rptDate,
        'Report Ref No    : SVR/'+String.valueOf(Date.today().year())+'/'+stCode+'/'+city.left(3).toUpperCase()+'/'+String.valueOf(1000+Math.mod(hv,8999)),
        'Prepared For     : Bank (Home Loan Processing)',
        'Borrower         : '+nm,
        '================================================================',
        'PROPERTY DESCRIPTION:',
        'Property Type    : '+pt,
        'Floor            : '+String.valueOf(floorNo)+'th Floor',
        'Location         : '+city+', '+st2+' - '+pin,
        'Super Built-up   : '+String.valueOf(sba)+' sq ft',
        'Carpet Area      : '+String.valueOf(carpetArea)+' sq ft',
        'Age of Building  : '+String.valueOf(Math.mod(hv,15)+1)+' years',
        'Construction     : Good (RCC Frame Structure)',
        '================================================================',
        'VALUATION METHODOLOGY: Sales Comparison + Income Approach',
        '',
        'COMPARATIVE MARKET ANALYSIS:',
        'Comparable Sale 1: Similar unit in same area Rs '+String.valueOf(marketVal-100000),
        'Comparable Sale 2: Nearby property Rs '+String.valueOf(marketVal-50000),
        'Comparable Sale 3: Recent registered sale Rs '+String.valueOf(marketVal+200000),
        '================================================================',
        'VALUATION SUMMARY:',
        'Market Value (As-Is) : Rs '+String.valueOf(marketVal),
        'Distress Value (80%) : Rs '+String.valueOf(distressVal),
        'Loan Recommended     : Rs '+String.valueOf(loanRec)+' (75% of MV)',
        '================================================================',
        'ENCUMBRANCE STATUS:',
        'EC Certificate       : VERIFIED (30 Years Clear)',
        'Existing Mortgage    : NONE',
        'Litigation           : NONE',
        '================================================================',
        'Valid till: '+validTill+' | Signed: Registered Valuer | '+vlr
    };
    batch.add(new ContentVersion(
        Title='Property Valuation Report - '+a.FirstName+' '+a.LastName,
        PathOnClient='PropertyValuation_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=u.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Property valuation reports inserted: '+cnt);
