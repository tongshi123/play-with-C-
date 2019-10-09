%% *****************************************************************************************
%  This M file is used to compute end-to-end flows, which begin with a source nodes, and pass through 
%  the gateway, and lastly end at a destination nodes.
%  Date: 2017/12/13
%  Deadline: 2017/12/13 20:30 (complete on time, very good)
%  Author: zhu yuanjie

%% ******************************* floyd method ******************************************
% INPUT:
% link_quality_matrix[][]: the link quality of every two nodes, where 0 presents that the two nodes can not conmmunication
% gateway: the gateway node ID
% s_d_pari[]: an array stored the node pair of flows
% n : the number of network nodes
% OUTPUT:
% path_flows{}: an cell array to store path that is from sources to destination nodes

function [path_flows]=floyd(link_quality_matrix,gateway,s_d_pair,n,DEBUG_MODE)
DEBUG=DEBUG_MODE;
P=zeros(n,n); % create a  2-dimensional matrixt with the same scale to link_quality_matrix
num_flows=size(s_d_pair,1); % calculate the number of rows of s_d_pair
path_flows=cell(num_flows,1); % cell array with num_flows-by-1
% initialize the matrix of P
for v=1:n
    for w=1:n
        P(v,w)=w;
    end
end

% floyd is used to find the shortest path, this expression can obtain reliable path
link_quality_matrix=1-link_quality_matrix; 
% core algorithm of floyd
for k=1:n
    for v=1:n
        for w=1:n
            if link_quality_matrix(v,w) > link_quality_matrix(v,k)+link_quality_matrix(k,w)
                link_quality_matrix(v,w)=link_quality_matrix(v,k)+link_quality_matrix(k,w);
                P(v,w)=P(v,k); % the path from node v to node w goes by the node=P(v,k)
            end
        end
    end
end
path=[];
for i=1:num_flows
    path=findPathInTwoNodes(P,n,gateway,s_d_pair(i,1),0);  % find the up path from sources to gateway
    path_flows{i}=[path_flows{i},path];
    path=findPathInTwoNodes(P,n,gateway,s_d_pair(i,2),1);  % find the down path from gateway to destination 
    path_flows{i}=[path_flows{i},path];
    if DEBUG==1   
        disp(['flow ',num2str(i),': ',num2str(path_flows{i}(1,:))]);  
    end
end

%% ********************** find the shortest path between two givn nodes ******************************
%INPUT:
%  P[][]: is a two dimentional matrix obtained from floyd algorithm
%  n :    is the total number of network nodes
%  gateway: the gateway node ID
%  nodeID : the node ID
%  direction: if it is 0 find the up path from nodeId to gateway; Otherwise, find a down path from gateway to nodeID
%OUTPUT:
%  path[]: an array to store the path of the given two nodes
%
% the algorithm computs a path between nodeID and gateway !.
% When invoking the function, nodeID is replaced with practical ID
function [path]=findPathInTwoNodes(P,n,gateway, nodeID, direction)
path=[]; % define a empty array
k=0;
if direction==0    % find the up path
    path=nodeID;
    k=P(nodeID,gateway);
    path=[path, k];
    while k ~= gateway  % if k is not gateway
        k=P(k,gateway);
        path=[path, k];
    end
else   % find the down path
    % path=gateway; % the UP path has already been included, thus the down path does not need
    k=P(gateway,nodeID);
    path=[path, k];
    while k ~= nodeID  % if k is not gateway
        k=P(k,nodeID);
        path=[path, k];
    end
end
