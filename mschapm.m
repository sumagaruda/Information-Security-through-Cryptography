clc;
clear;
 
tsha1= 0.0384; %sha1
tmd4= 0.0476; %md4
tsha256= 0.05;
tdese= 0.29165 %desencryption
tdesd= 0.29165 %desdecryption
trsae= 0.14285 %rsaencryption
trsad= 0.14285 %trsadecryption
 
%MS-CHAPV2 AUTHENTICATION
CHAPo_a = [tsha1+tmd4+3*tdese, trsad, tmd4+tsha1+tsha1, trsae, trsad];
CHAPo_b= [tsha1+tmd4+3*tdese, trsae, tmd4+tsha1+tsha1, trsad, trsae];
CHAPo=[tsha1+tmd4+3*tdese, tsha1+tmd4+3*tdese +3*tdesd, trsae, trsad tmd4+tsha1+tsha1, tmd4+tsha1+tsha1, trsae, trsad, trsae, trsad];
 
%total===============================
for tmp = 2:length(CHAPo_a);
    CHAPo_a (tmp)= CHAPo_a (tmp-1)+ CHAPo_a (tmp);        
end
 
for tmp = 2:length(CHAPo);
    CHAPo (tmp)= CHAPo (tmp-1)+ CHAPo (tmp);        
end
 
%MS-CHAPV2 AUTHENTICATION Modified
CHAPm_a = [2*trsad, 2*trsae+tsha1+tmd4+tdese+3*tdese, 2*trsad, tsha256, 2*trsae, 2*trsad];
CHAPm_b= [2*trsae, 2*trsad+tsha1+tmd4+tdese+3*tdese, 2*trsae, tsha256,2*trsad, 2*trsae];
CHAPm=[2*trsae,2*trsad, 2*trsae+tsha1+tmd4+tdese+3*tdese, 2*trsad+tsha1+tmd4+tdese+3*tdese, 2*trsae, 2*trsad, tsha256, tsha256,2*trsae,2*trsad, 2*trsae, 2*trsad ]
 
%total===============================
for tmp = 2:length(CHAPm_a);
    CHAPm_a (tmp)= CHAPm_a (tmp-1)+ CHAPm_a (tmp);        
end
 
for tmp = 2:length(CHAPm);
    CHAPm (tmp)= CHAPm (tmp-1)+ CHAPm (tmp);        
end
 
 
total_number = 100000;
unkown_attacks= 0;
y_mschapo = zeros(1,10);
y_mschapm= zeros(1,10);
left_time_mschapo= 0;
left_time_mschapm=0;
n=1;
 
for x=0:0.1:0.9
 
    left_time_mschapo= total_number*(1-x)*CHAPo_a(length(CHAPo_a));
    left_time_mschapm= total_number*(1-x)*CHAPm_a(length(CHAPm_a));
    
   unknown_attacks = uint16(total_number*x);
    
   unexpected_delay_mschapo = randi([1,length(CHAPo_a)],1,unknown_attacks); 
  unexpected_delay_mschapm = randi([1,length(CHAPm_a)],1,unknown_attacks);
  
   attack_total_delay_mschapo= 0;
    attack_total_delay_mschapm= 0;
 
    for i=1:unknown_attacks
 
attack_total_delay_mschapo = attack_total_delay_mschapo + CHAPo_a(unexpected_delay_mschapo(i));
attack_total_delay_mschapm=attack_total_delay_mschapm+CHAPm_a(unexpected_delay_mschapm(i));
 
    end
 
    y_mschapo(n)=(left_time_mschapo+attack_total_delay_mschapo)/(total_number*(1-x));
    y_mschapm(n)=(left_time_mschapm+attack_total_delay_mschapm)/(total_number*(1-x));
    
    n=n+1;
end
 
x=0:0.1:0.9;
%figure;
plot(x,y_mschapo,'-k', x, y_mschapm,'-.k');
set(gca,'XTick',0:0.1:1);
set(gca, 'xticklabel', {'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'});
% title('Delay','fontsize',12);
xlabel('Ratio of Unknown to Known attacks','fontsize',12);
ylabel('Total Time Delay (ms)','fontsize',12);
legend({'MSCHAPo', 'MSCHAPm'},'FontSize',12,'FontWeight','bold');
axis([0,0.9,0,10]);
 
