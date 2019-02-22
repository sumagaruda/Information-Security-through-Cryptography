clc;
clear;
 
trsae= 0.1667 %rsaencryption
trsad= 0.1667 %rsadecryption
thmacsha256= 0.0714
tsha1= 0.0384; %sha
tsha256= 0.05 %sha256
tdese= 0.29165; %desencryption
tdesd= 0.29165; %desdecryption
tmd4= 0.0476
 
%EAP-TTLS AUTHENTICATION
eapttlso_a = [trsae, 5*thmacsha256+2*thmacsha256, 2*thmacsha256,14*thmacsha256+2*thmacsha256+tdese, tdesd];
eapttlso_b= [trsad,5*thmacsha256+2*thmacsha256, 2*thmacsha256,14*thmacsha256+2*thmacsha256+tdesd, tdese];
eapttlso=[ trsae, trsad, 5*thmacsha256+2*thmacsha256, 5*thmacsha256+2*thmacsha256, 2*thmacsha256, 2*thmacsha256, 14*thmacsha256+2*thmacsha256+tdese, 14*thmacsha256+2*thmacsha256+tdesd,tdese,tdesd ];
 
%total===============================
for tmp = 2:length(eapttlso_a);
    eapttlso_a (tmp)= eapttlso_a (tmp-1)+ eapttlso_a (tmp);        
end
 
for tmp = 2:length(eapttlso);
    eapttlso (tmp)= eapttlso (tmp-1)+ eapttlso (tmp);        
end
 
%EAP-TLS AUTHENTICATION Modified
eapttlsm_a = [trsae, 2*thmacsha256+tsha1+thmacsha256,thmacsha256,4*thmacsha256+6*tsha1+tmd4+tdese, tdesd];
eapttlsm_b= [trsad,2*thmacsha256+tsha1+thmacsha256, thmacsha256, 4*thmacsha256+tsha1+tmd4+tdesd, tdese];
eapttlsm=[trsae, trsad, 2*thmacsha256+tsha1+thmacsha256, 2*thmacsha256+tsha1+thmacsha256, thmacsha256, thmacsha256, 4*thmacsha256+6*tsha1+tmd4+tdese, 4*thmacsha256+tsha1+tmd4+tdesd, tdese, tdesd];
 
%total===============================
for tmp = 2:length(eapttlsm_a);
    eapttlsm_a (tmp)= eapttlsm_a (tmp-1)+ eapttlsm_a (tmp);        
end
 
for tmp = 2:length(eapttlsm);
    eapttlsm (tmp)= eapttlsm (tmp-1)+ eapttlsm (tmp);        
end
 
 
total_number = 100000;
unkown_attacks= 0;
y_eapttlso = zeros(1,10);
y_eapttlsm= zeros(1,10);
left_time_eapttlso= 0;
left_time_eapttlsm=0;
n=1;
 
for x=0:0.1:0.9
 
  left_time_eapttlso= total_number*(1-x)*eapttlso_a(length(eapttlso_a));
  left_time_eapttlsm= total_number*(1-x)*eapttlsm_a(length(eapttlsm_a));
    
  unknown_attacks = uint16(total_number*x);
    
 unexpected_delay_eapttlso = randi([1,length(eapttlso_a)],1,unknown_attacks); 
 unexpected_delay_eapttlsm = randi([1,length(eapttlsm_a)],1,unknown_attacks);
  
   attack_total_delay_eapttlso= 0;
    attack_total_delay_eapttlsm= 0;
 
    for i=1:unknown_attacks
 
attack_total_delay_eapttlso = attack_total_delay_eapttlso + eapttlso_a(unexpected_delay_eapttlso(i));
attack_total_delay_eapttlsm=attack_total_delay_eapttlsm+eapttlsm_a(unexpected_delay_eapttlsm(i));
 
    end
 
    y_eapttlso(n)=(left_time_eapttlso+attack_total_delay_eapttlso)/(total_number*(1-x));
    y_eapttlsm(n)=(left_time_eapttlsm+attack_total_delay_eapttlsm)/(total_number*(1-x));
    
    n=n+1;
end
 
x=0:0.1:0.9;
%figure;
plot(x,y_eapttlso,'-k', x, y_eapttlsm,'-.k');
set(gca,'XTick',0:0.1:1);
set(gca, 'xticklabel', {'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'});
xlabel('Ratio of unknown to known attacks','fontsize',12);
ylabel('Total Time Delay (ms)','fontsize',12);
legend({'EAP-TTLSo', 'EAP-TTLSm'},'FontSize',12,'FontWeight','bold');
axis([0,0.9,0,10]);

