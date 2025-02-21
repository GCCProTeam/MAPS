function dX_GDV = calGDV(prn, el)
%Calculates the correction for the Group Delay Variation depending on the
%satellite system, satellite type, elevation and processed
%frequency/ionosphere modell

%INPUT:
%prn: raPPPid satellite number
%el: elevation of satellite [dgree]

%OUTPUT:
%dX_GDV: Group Delay Variation correction, add to code observation

% This function belongs to raPPPid, Copyright (c) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------

prn=prn-68+300;

dX_GDV = [0,0,0];
%% Get GDV valus depending on GNSS and satellite type
if prn > 300        % BDS satellite
    
    % status: 25.Feb 2020, https://www.glonass-iac.ru/en/BEIDOU/
    % ||| change this to IGS MGEX Metadata file at some point!!!
    GEO = [301 302 303 304 305];
    IGSO = [306 307 308 309 310 313 316 338 339 340 331 356];
    MEO = [311 312 314 318];        % only BeiDou-2 MEO
%     MEO = [311 312 314 318 319 320 321 322 323 324 325 326 327 328 329 330 ...
%         332 333 334 335 336 337 343 344 359  341 342 345 346 357 358];
    
    % check for satellite type
    isGEO  = any(prn == GEO);
    isIGSO = any(prn == IGSO);
    isMEO  = any(prn == MEO);
    
    if ~(isGEO || isIGSO || isMEO)
        % BeiDou 3 MEO -> no GDVs
        return
    end

    % group delay values for BeiDou 2 IGSO satellite, [18]
    % elevation | B1 | B2 | B3
    GDV_BDS_IGSO = [...
        0 	-0.55 	-0.71 	-0.27;  ...
        10 	-0.40 	-0.36 	-0.23;  ...
        20 	-0.34 	-0.33 	-0.21;  ...
        30 	-0.23 	-0.19 	-0.15;  ...
        40 	-0.15 	-0.14 	-0.11;  ...
        50 	-0.04 	-0.03 	-0.04;  ...
        60 	 0.09 	 0.08 	 0.05;  ...
        70 	 0.19 	 0.17 	 0.14;  ...
        80 	 0.27 	 0.24 	 0.19;  ...
        90   0.35 	 0.33 	 0.32;  ];
    % group delay values for BeiDou 2 MEO satellite, [18]
    % elevation | B1 | B2 | B3
    GDV_BDS_MEO  = [...
        0  	-0.47 	-0.40 	-0.22;	...
        10 	-0.38 	-0.31 	-0.15;	...
        20	-0.32 	-0.26 	-0.13;	...
        30 	-0.23 	-0.18 	-0.10;	...
        40	-0.11 	-0.06 	-0.04;	...
        50	 0.06 	 0.09 	 0.05;	...
        60	 0.34 	 0.28 	 0.14;	...
        70	 0.69 	 0.48 	 0.27;	...
        80	 0.97 	 0.64 	 0.36;	...
        90	 1.05 	 0.69 	 0.47;	];
    % group delay values for BeiDou GEO satellites are not detectable
    % because it is observed with constant elevation (geostationary)
    GDV_BDS_GEO = zeros(10,4);
    GDV_BDS_GEO(:,1) = GDV_BDS_MEO(:,1);
    
    
    GDV = isIGSO*GDV_BDS_IGSO + isMEO*GDV_BDS_MEO + isGEO*GDV_BDS_GEO;

else 
    % currently GDVs are neglected for other GNSS. This might change in the
    % future.
    return
end

%% interpolate GDV correction for elevation of satellite
dX_GDV_(1) = interp1(GDV(:,1), GDV(:,2), el);
dX_GDV_(2) = interp1(GDV(:,1), GDV(:,3), el);
dX_GDV_(3) = interp1(GDV(:,1), GDV(:,4), el);

%% consider processed frequency
    % resort depending on processed frequenceis
    dX_GDV = [dX_GDV_(1) dX_GDV_(3)];
end
