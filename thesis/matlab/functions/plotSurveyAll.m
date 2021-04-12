function plotSurveyAll(which)
    arguments
        which (1,1) string = "four"
    end
    
    paths = ["survey_theo","survey_jakob","survey_ronja","survey_helmut","survey_leia","survey_birgit"];
    
    for pathInd = 1:length(paths)
        plotSurvey(paths(pathInd),"Which",which);
    end
end