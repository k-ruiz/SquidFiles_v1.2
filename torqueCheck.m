
% Calculate the torques of the system. See ricardo notes in t_notes

Ubdry = zeros(2*length(stks(:,1)),1);
Ubdry(1:2:end) = stks(:,4);
Ubdry(2:2:end) = stks(:,5);

Ubdry = [Ubdry;0;0;0];
Fvert = iS*Ubdry;
F = zeros(length(stks(:,1)),2);
F(:,1) = Fvert(1:2:end-3);
F(:,2) = Fvert(2:2:end-3);

%%

torque = [0,0,0]'; % Initialise the torque

% Set position about which the torque is calculated
xc = 0; yc = 0; zc = 0;

% Loop through each of the forces and take the torque about the point
for i = 1:length(stks(:,1))

    K = [0,0,-(stks(i,2)-yc); ...
         0,0, (stks(i,1)-xc); ...
         (stks(i,2)-yc),-(stks(i,1)-xc),0];

    torque = torque + K'*[F(i,1),F(i,2),0]'; % add this contribution to the total

end
