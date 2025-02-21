function [X_rot] = calPCOCorr(input,X_rot,SatOr_ECEF,sv)
%Corrects satellite position for Phase Center Offsets (PCO) 
%and transforms them into ECEF coordinates

%INPUT:
%input: Structure containing receiver position, PCO data, and frequency information
%X_rot: Satellite position in ECEF coordinates (meters)
%SatOr_ECEF: Satellite orientation matrix in ECEF coordinates
%sv: Satellite number (PRN)

%OUTPUT:
%X_rot: Corrected satellite position in ECEF coordinates (meters)

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
    offset_LL=[];
    % satellite Phase Center Offset and precise ephemerides are enabled
    if sv<=32          % get offsets for current satellite
        prn=sv;
        offset_LL = input.PCO.sat_GPS(input.PCO.sat_GPS(:,1) == prn, 2:4, 1:5); 
    elseif sv>32&&sv<=68
        prn=sv-32;
        offset_LL = input.PCO.sat_GAL(input.PCO.sat_GAL(:,1) == prn, 2:4, 1:5);
    else
        prn=sv-68;
        offset_LL = input.PCO.sat_BDS(input.PCO.sat_BDS(:,1) == prn, 2:4, 1:5);           
    end
    % --- Theoretical Range and Line-of-sight-Vector ---
    rec_XYZ=input.rec_XYZ;
    los  = X_rot - rec_XYZ';         % vector from receiver to satellite, Line-of-sight-Vector
    rho  = norm(los);               % distance from receiver to satellite
    los0 = los/rho;                 % unit vector from receiver to satellite
    offset_LL = reshape(offset_LL,3,5,1);   % each column contains another frequency
    dX_PCO_SAT_ECEF = SatOr_ECEF*offset_LL;   	% transform offsets into ECEF site displacements
    f1=input.f1(sv,1);
    f2=input.f2(sv,1);
    c1=f1^2/(f1^2-f2^2);
    c2=-f2^2/(f1^2-f2^2);
    for kk=1:3
        dant(kk)=c1*dX_PCO_SAT_ECEF(kk,1)+c2*dX_PCO_SAT_ECEF(kk,2);
    end  
    for kk=1:3
        X_rot(kk)=X_rot(kk)+dant(kk);
    end          
end