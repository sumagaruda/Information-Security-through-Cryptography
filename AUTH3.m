clc;
clear;
%Authentication==========

%functions===================
th =  0.0601; %hash
tm = 0.0789;  %HMAC
ta = 0.1447;  %AES
ts = 0.8521;  %ECDSA sign
tv = 0.9060;  %ECDSA Verify
tp = 0.2414;  %point multiplication

%SPAM AUTHENTICATION
SPAM_MN = [ta+3*th,ta,th,ta+th];
SPAM_MAG = [2*ta+5*th,ta+2*th,ta,th+ta,th+ta,th+ta];
SPAM_LMA = [ta+th,2*th+ta,ta];
SPAM=[th,ta+2*th,2*ta+5*th,ta+2*th,ta+th,ta+th,ta,th+ta,ta+th,2*th+ta,th+ta,th+ta,ta];

%total===============================
for tmp = 2:length(SPAM_MN);
    SPAM_MN(tmp)=SPAM_MN(tmp-1)+SPAM_MN(tmp);        
end

for tmp = 2:length(SPAM);
    SPAM(tmp)=SPAM(tmp-1)+SPAM(tmp);        
end

%EAKES6Lo AUTHENTICATION
EAKES6Lo_MN = [ta+ts,tv,tm];
EAKES6Lo_MAG = [tv,tv];
EAKES6Lo_LMA = [tv,tm+ts,tv];
EAKES6Lo_AAA = [tv,tv,tm,ta,ts+tm];
EAKES6Lo=[ta+ts,tv,tv,tm+ts,tv,tv,tm,ta,ts+tm,tv,tv,tv,tm];

%total===============================
for tmp = 2:length(EAKES6Lo_MN);
    EAKES6Lo_MN(tmp)=EAKES6Lo_MN(tmp-1)+EAKES6Lo_MN(tmp);        
end

for tmp = 2:length(EAKES6Lo);
    EAKES6Lo(tmp)=EAKES6Lo(tmp-1)+EAKES6Lo(tmp);        
end



%ESPH AUTHENTICATION
ESPH_MN = [th+ta,ta];
ESPH_MAG = [tv,th,tp,tm,th+tm,ta,ta,ta];
ESPH_LMA = [tm,tm,tm+th,tm+2*th,ta,ta];
ESPH_AAA = [tm,ta,6*th+tm];
ESPH=[th+ta,tv,th,tp,tm,tm,tm,tm,ta,6*th+tm,tm+th,tm+2*th,th+tm,ta,ta,ta,ta,ta,ta];

%total===============================
for tmp = 2:length(ESPH_MN);
    ESPH_MN(tmp)=ESPH_MN(tmp-1)+ESPH_MN(tmp);        
end

for tmp = 2:length(ESPH);
    ESPH(tmp)=ESPH(tmp-1)+ESPH(tmp);        
end

%============================================
OURS_MN=ESPH_MN;
%===========================================
total_number = 10000;
attack_real_number= 0;
y_sake = zeros(1,10);
y_eake = zeros(1,10);
y_our = zeros(1,10);
left_time_SAKES= 0;
left_time_EAKES= 0;
left_time_OUR= 0;
n=1;

for x=0:0.1:0.9
    left_time_SAKES = total_number*(1-x)*SPAM_MN(length(SPAM_MN));
    left_time_EAKES = total_number*(1-x)*EAKES6Lo_MN(length(EAKES6Lo_MN));
	left_time_OUR = total_number*(1-x)*OURS_MN(length(OURS_MN));
    
	attack_real_number = uint16(total_number*x);
    
	counts_SAKES = randi([1,length(SPAM_MN)],1,attack_real_number); 
    counts_EAKES = randi([1,length(EAKES6Lo_MN)],1,attack_real_number);
	counts_OUR = randi([1,length(OURS_MN)],1,attack_real_number); 
,    
	attack_total_delay_SAKES = 0;
    attack_total_delay_EAKES = 0;
	attack_total_delay_OUR = 0;
    
	for i=1:attack_real_number
        attack_total_delay_SAKES = attack_total_delay_SAKES + SPAM_MN(counts_SAKES(i));
        attack_total_delay_EAKES = attack_total_delay_EAKES + EAKES6Lo_MN(counts_EAKES(i));
		attack_total_delay_OUR = attack_total_delay_OUR + OURS_MN(counts_OUR(i)); 
	end

	y_sake(n)=(left_time_SAKES+attack_total_delay_SAKES)/(total_number*(1-x));
    y_eake(n)=(left_time_EAKES+attack_total_delay_EAKES)/(total_number*(1-x));
	y_our(n)=(left_time_OUR+attack_total_delay_OUR)/(total_number*(1-x));
    
    n=n+1;
end

x=0:0.1:0.9;
%figure;
plot(x,y_sake,'-k',x,y_eake,'-ok',x,y_our,'-.k');
set(gca,'XTick',0:0.1:1);
set(gca, 'xticklabel', {'0%','10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'});
% title('Time Consumption of MN between SPAM and OURS','fontsize',12);
xlabel('The Probability of Successful Attacks','fontsize',12);
ylabel('Total Time Delay (ms)','fontsize',12);
legend({'SPAM','EAKES6Lo','ESPH'},'FontSize',12,'FontWeight','bold');
axis([0,0.9,0,6]);
