clc;
clear;
 
trsae= 0.1667 %rsaencryption
trsad= 0.1667 %rsadecryption
thmacsha256= 0.0714
tsha1= 0.0384; %sha
tsha256= 0.05 %sha256
tmd5= 0.05263; %md5
tdese= 0.29165; %desencryption
tdesd= 0.29165; %desdecryption
 
%EAP-TLS AUTHENTICATION
eaptlso_a = [trsae,tsha1+trsae,5*thmacsha256+2*thmacsha256, 2*thmacsha256,14*thmacsha256+tdesd,tdese];
eaptlso_b= [trsad,tsha1+trsae,5*thmacsha256+2*thmacsha256, 2*thmacsha256,14*thmacsha256+tdese,tdesd];
eaptlso=[trsae,trsad,tsha1+trsae,tsha1+trsad, 5*thmacsha256+2*thmacsha256, 5*thmacsha256+2*thmacsha256,2*thmacsha256,2*thmacsha256,14*thmacsha256+tdese,14*thmacsha256+tdesd+tdese,tdesd];
 
%total===============================
for tmp = 2:length(eaptlso_a);
    eaptlso_a (tmp)= eaptlso_a (tmp-1)+ eaptlso_a (tmp);        
end
 
for tmp = 2:length(eaptlso);
    eaptlso (tmp)= eaptlso (tmp-1)+ eaptlso (tmp);        
end
 
%EAP-TLS AUTHENTICATION Modified
eaptlsm_a = [trsae, tsha1+trsae, 2*thmacsha256+tsha1+thmacsha256, 4*thmacsha256+6*tsha1+tdesd,tdese];
eaptlsm_b= [trsad,tsha1+trsad, 2*thmacsha256+tsha1+thmacsha256, 4*thmacsha256+6*tsha1+tdese, tdesd];
eaptlsm=[trsae, trsad,tsha1+trsae, tsha1+trsad, 3*thmacsha256+tsha256+thmacsha256,3*thmacsha256+tsha256+thmacsha256,10*thmacsha256+tdese,10*thmacsha256+tdesd+tdese,tdesd];
 
%total===============================
for tmp = 2:length(eaptlsm_a);
    eaptlsm_a (tmp)= eaptlsm_a (tmp-1)+ eaptlsm_a (tmp);        
end
 
for tmp = 2:length(eaptlsm);
    eaptlsm (tmp)= eaptlsm (tmp-1)+ eaptlsm (tmp);        
end
 
 
total_number = 100000;
unkown_attacks= 0;
y_eaptlso = zeros(1,10);
y_eaptlsm= zeros(1,10);
left_time_eaptlso= 0;
left_time_eaptlsm=0;
n=1;
 
for x=0:0.1:0.9
 
    left_time_eaptlso= total_number*(1-x)*eaptlso_a(length(eaptlso_a));
    left_time_eaptlsm= total_number*(1-x)*eaptlsm_a(length(eaptlsm_a));
    
   unknown_attacks = uint16(total_number*x);
    
   unexpected_delay_eaptlso = randi([1,length(eaptlso_a)],1,unknown_attacks); 
  unexpected_delay_eaptlsm = randi([1,length(eaptlsm_a)],1,unknown_attacks);
  
   attack_total_delay_eaptlso= 0;
    attack_total_delay_eaptlsm= 0;
 
    for i=1:unknown_attacks
 
attack_total_delay_eaptlso = attack_total_delay_eaptlso + eaptlso_a(unexpected_delay_eaptlso(i));
attack_total_delay_eaptlsm=attack_total_delay_eaptlsm+eaptlsm_a(unexpected_delay_eaptlsm(i));
 
    end
 
    y_eaptlso(n)=(left_time_eaptlso+attack_total_delay_eaptlso)/(total_number*(1-x));
    y_eaptlsm(n)=(left_time_eaptlsm+attack_total_delay_eaptlsm)/(total_number*(1-x));
    
    n=n+1;
end
 
x=0:0.1:0.9;
%figure;
plot(x,y_eaptlso,'-k', x, y_eaptlsm,'-.k');
set(gca,'XTick',0:0.1:1);
set(gca, 'xticklabel', {'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'});
xlabel('Ratio of unknown to known attacks','fontsize',12);
ylabel('Total Time Delay (ms)','fontsize',12);
legend({'EAP-TLSo', 'EAP-TLSm'},'FontSize',12,'FontWeight','bold');
axis([0,0.9,0,10]);
 
 
