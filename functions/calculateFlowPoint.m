%% Function to calculate the flow profile generated by some collection of Stokeslets over some pre-defined grid

function [Uflowx,Uflowy] = calculateFlowPoint(stks1,F1,x1,y1,eps1,Uback1)

    % Preallocate the arrays for magnitudes of flow in each component
    Uflowx = zeros(length(x1),length(y1)); % X-component of the flow
    Uflowy = zeros(length(x1),length(y1)); % Y-component of the flow
    [nStok,~] = size(stks1); % Total number of Stokeslets 

    % Scan through the whole grid 
    for xposition = 1:length(x1)
        parfor yposition = 1:length(y1)

            Stemp = zeros(2,2); % Store for the Stokeslet between the current point of consideration [xposition,yposition] and the collection of Stokeslets

            % Local parameter copies, needed for parallelisation
            tempStks = stks1(:,1:2); tempF = F1; tempX = x1; tempY = y1;

            p = [tempX(xposition),tempY(yposition)]'; % Get the coordinates of position of consideration

            % Loop through the Stokeslets that can generate a flow at the position being considered
            for n = 1:nStok

                pN = tempStks(n,:)'; % Get the position of stokeslet N.
                Ftemp = tempF(n,:)'; % Get the forces of stokeslet N.
                r = sqrt(norm(p - pN).^2 + eps1^2) + eps1; % Distance, considered to stokeslet N.
                rho = (r+eps1)/(r*(r-eps1)); % Rho, considered to stokeslet N.

                % Construct the Stokeslet contribution for this comparison
                for k = 1:2
                    for l = 1:2
                        Stemp(k,l) = -(log(r)-eps1*rho)*(k==l) + (p(k)-tempStks(n,k))*(p(l)-tempStks(n,l))*rho/r;
                    end
                end

                % Get the flow due to Stokeslet n and add it to the overall flow calculated
                U = Stemp*Ftemp;
                Uflowx(xposition,yposition) = Uflowx(xposition,yposition) + U(1);
                Uflowy(xposition,yposition) = Uflowy(xposition,yposition) + U(2);

            end

        end
    end

    Uflowx = Uflowx + Uback1(1);
    Uflowy = Uflowy + Uback1(2);

end

