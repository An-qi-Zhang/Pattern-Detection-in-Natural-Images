function StatsOut = computeSceneStats(scene, targets, envelope, coords, pixelMax)
%COMPUTESCENESTATS Computes statistics a given scene
%
% Example: 
%   StatsOut = COMPUTESCENESTATS(scene, targets, envelope, coords, pixelMax);
% 
% Output:
%   StatsOut.L:        Mean luminance 
%   StatsOut.C:        RMS contrast
%   StatsOut.S:        phase invariant similarity for each target
%   StatsOut.Sa:       phase specific similarity for each target
%   StatsOut.tMatch:   template match for each target
%   StatsOut.pClipped: percentage pixels clipped in each region
%  
%   See also COMPUTESCENELUMINANCE, COMPUTESCENECONTRAST, COMPUTESCENESIMILARITYANGLE,
%            COMPUTESCENESIMILARITYSPATIAL.
%
% v1.0, 1/5/2016, Steve Sebastian <sebastian@utexas.edu>


%% Check input.
if (nargin < 4)
    coords = [];
end

nTargets = size(targets,3);

%% Calculate stats.
Lstats  = nm.stats.computeSceneLuminance(scene, envelope, coords);
Cstats  = nm.stats.computeSceneContrast(scene, envelope, coords);
Pstats  = nm.stats.computeScenePercentClipped(scene, envelope, coords);

for iTarget = 1:nTargets
    Sastats  = nm.stats.computeSceneSimilarityAmplitude(scene, targets(:,:,iTarget), envelope, coords);
    Ssstats  = nm.stats.computeSceneSimilaritySpatial(scene, targets(:,:,iTarget), envelope, coords);
    Tstats   = nm.stats.computeSceneTemplateMatch(scene, targets(:,:,iTarget), coords);
    
    StatsOut.Ss{iTarget} = Ssstats.Smag;
    StatsOut.Sa{iTarget} = Sastats.Smag;
    StatsOut.tMatch{iTarget} = Tstats.tMatch;
end

%% Output
StatsOut.L  = Lstats.L;
StatsOut.C  = Cstats.Crms;
StatsOut.pClipped = Pstats.pClipped;

% Convert luminance to % luminance
if(exist('pixelMax', 'var') || ~isempty(pixelMax))
    StatsOut.L = (StatsOut.L./(pixelMax)).*100;
end
