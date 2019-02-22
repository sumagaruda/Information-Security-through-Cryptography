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
 
%PEAP AUTHENTICATION
peapo_a = [trsae,5*thmacsha256+2*thmacsha256, 2*thmacsha256,14*thmacsha256+tdese,tdesd, tmd5+tdese, tdesd];
peapo_b= [trsad,5*thmacsha256+2*thmacsha256, 2*thmacsha256,14*thmacsha256+tdesd, tdese,tdesd+tmd5, tdese];
peapo=[trsae,trsad,5*thmacsha256+2*thmacsha256, 5*thmacsha256+ 2*thmacsha256, 2*thmacsha256,2*thmacsha256, 14*thmacsha256 + tdese,14*thmacsha256+tdesd, tdese, tdesd, tmd5+tdese,tdesd+tmd5,tdese,tdesd];
 
%total===============================
for tmp = 2:length(peapo_a);
    peapo_a (tmp)= peapo_a (tmp-1)+ peapo_a (tmp);        
end
 
for tmp = 2:length(peapo);
    peapo (tmp)= peapo (tmp-1)+ peapo (tmp);        
end
 
%PEAP AUTHENTICATION Modified
peapm_a = [trsae, 2*thmacsha256+tsha1+thmacsha256,thmacsha256, 4*thmacsha256+6*tsha1+tdese, tdesd, tmd5+tdese, tdesd];
peapm_b= [trsad, 2*thmacsha256+tsha1+thmacsha256,thmacsha256, 4*thmacsha256+6*tsha1+tdesd, tdese, tmd5+tdesd, tdese];
peapm=[trsae, trsad, 2*thmacsha256+tsha1+thmacsha256, 2*thmacsha256+tsha1+thmacsha256, thmacsha256, thmacsha256, 4*thmacsha256+6*tsha1+tdese, 4*thmacsha256+6*tsha1+tdesd,tdese, tdesd, tmd5+tdese, tmd5+tdesd, tdese, tdesd];
 
%total===============================
for tmp = 2:length(peapm_a);
    peapm_a (tmp)= peapm_a (tmp-1)+ peapm_a (tmp);        
end
 
for tmp = 2:length(peapm);
    peapm (tmp)= peapm (tmp-1)+ peapm (tmp);        
end
 
 
total_number = 100000;
unkown_attacks= 0;
y_peapo = zeros(1,10);
y_peapm= zeros(1,10);
left_time_peapo= 0;
left_time_peapm=0;
n=1;
 
for x=0:0.1:0.9
 
    left_time_peapo= total_number*(1-x)*peapo_a(length(peapo_a));
    left_time_peapm= total_number*(1-x)*peapm_a(length(peapm_a));
    
   unknown_attacks = uint16(total_number*x);
    
   unexpected_delay_peapo = randi([1,length(peapo_a)],1,unknown_attacks); 
  unexpected_delay_peapm = randi([1,length(peapm_a)],1,unknown_attacks);
  
   attack_total_delay_peapo= 0;
    attack_total_delay_peapm= 0;
 
    for i=1:unknown_attacks
 
attack_total_delay_peapo = attack_total_delay_peapo + peapo_a(unexpected_delay_peapo(i));
attack_total_delay_peapm=attack_total_delay_peapm+peapm_a(unexpected_delay_peapm(i));
 
    end
 
    y_peapo(n)=(left_time_peapo+attack_total_delay_peapo)/(total_number*(1-x));
    y_peapm(n)=(left_time_peapm+attack_total_delay_peapm)/(total_number*(1-x));
    
    n=n+1;
end
 
x=0:0.1:0.9;
%figure;
plot(x,y_peapo,'-k', x, y_peapm,'-.k');
set(gca,'XTick',0:0.1:1);
set(gca, 'xticklabel', {'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'});
xlabel('Ratio of unknown to known attacks','fontsize',12);
ylabel('Total Time Delay (ms)','fontsize',12);
legend({'PEAPo', 'PEAPm'},'FontSize',12,'FontWeight','bold');
axis([0,0.9,0,10]);
 
 
 
 

