function [outputH,outputG]=GassianXY(inputx,inputy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%---- �ó����Ŀ�ģ�����У�����x���ڶ�Ԫ���϶�x���и�˹��ȥ����H��Ȼ�������H��Ӧ�����ɾ���G�����H��G ----%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%----�ο����ݣ�x (��˹��ȥ) -> H=[I|P] -> G=[P'|I]G ------%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%-----------��һ��: ��ʼ��������� ---------------%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = inputx;
flag = inputy;%��־λ��ȷ��������ɵ�G���ұ�Ϊ��λ��(flag = 1),�������Ϊ��λ��(flag = else)
H1 = H;
[m,n] = size(H);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%------------------�ڶ�������˹��ȥ----------------%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%----    ��һ���H��ÿ��,H(i,:),����i=1:m,��H(i,i)==0,��   ----%%%%
%%%----Ѱ�Ҹ����е�һ������Ԫ,��¼�÷���Ԫ����,����H�ĸ�����   ----%%%%
%%%----H�ĵ�i�н���;��H(i,i)==1,����Ҫ�н���.Ȼ���齻���� ----%%%%
%%%----���߲���Ҫ������H(:,i),��H(i,i)Ԫ�����µĵ�i+1�е�m�� ----%%%%
%%%----�Ƿ��з���Ԫ,��,��H�ĵ�i�е��ӵ�����,��,����H��  ----%%%%
%%%----��һ��,ѭ��.����ǽ�Hת��Ϊһ�����·�Ϊȫ0,H(i,i)ȫ1�� ----%%%%
%%%----����,��ΪHmid,�ٶ�Hmid�Ե�m�����j�е���,j=m-1:-1:1, -----%%%%
%%%----ѭ��֮��õ����Ϊ��λ��ľ���[I|P]                  -----%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:m; % ��һ���H��ÿ�У�H(i,:)
   if H1(i,i)==0;% ��H(i,i)==0�ķ�֧
      j=min(find(H1(i,:)));% Ѱ�Ҹ����е�һ������Ԫ����¼�÷���Ԫ����
      H1(:,[i j])=H1(:,[j,i]);% ��H�ĸ�����H�ĵ�i�н�����H������Ϊ��������ľ���H1��������
      H(:,[i j])=H(:,[j,i]);
      for k=i+1:m;% ��H(i,i)Ԫ�����µĵ�i+1�е�m���Ƿ��з���Ԫ
          if H1(k,i)==1;% �У���H�ĵ�i�е��ӵ�����
             H1(k,:)=H1(i,:)+H1(k,:);
             H1(k,:)=mod(H1(k,:),2);
          end;% ��,����H����һ��
      end;
   else;% ��H(i,i)==1�ķ�֧������Ҫ�����У�ֻ��Ҫ���H(i,i)Ԫ�����µĵ�i+1�е�m���Ƿ��з���Ԫ
      for k=i+1:m;
          if H1(k,i)==1;% �У���H�ĵ�i�е��ӵ�����
             H1(k,:)=H1(i,:)+H1(k,:);
             H1(k,:)=mod(H1(k,:),2);
          end;
      end;
   end;% ��,����H����һ��
end;

for i=m:-1:2;% �Ե�m�����j�е���,j=m-1:-1:1
  for k=i-1:-1:1;
    if H1(k,i)==1;
       H1(k,:)=H1(i,:)+H1(k,:);
       H1(k,:)=mod(H1(k,:),2);
    end;
  end;% ѭ��֮��õ����Ϊ��λ��ľ���H1 = [I|P]��H1��Ӧ��H
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%-----------------���������õ�����G----------------%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag ==1;% G���ұ��ǵ�λ��
   PP = H1(:,m+1:n);% ȡ��H1�ĵ�m+1��n��
   G = [PP.' diag(ones(1,n-m))];%  H1=[I|P] -> G=[P'|I]
   outputH = H;
   outputG = G;% �ɼ�����ʱӦ��ȡx_hat�ĺ�n-m�����ݲ��ܵõ�ԭʼ����
else;% G�����Ϊ��λ��
   PP = H1(:,m+1:n);
   GT = [diag(ones(1,n-m));PP];
   outputH = [H(:,m+1:n) H(:,1:m)];
   outputG = GT.';
end;