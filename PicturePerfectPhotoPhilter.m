classdef PicturePerfectPhotoPhilter < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        ImageAxes              matlab.ui.control.UIAxes
        LoadButton             matlab.ui.control.Button
        BrightnessSliderLabel  matlab.ui.control.Label
        BrightnessSlider       matlab.ui.control.Slider
        RedSliderLabel         matlab.ui.control.Label
        RedSlider              matlab.ui.control.Slider
        GreenSliderLabel       matlab.ui.control.Label
        GreenSlider            matlab.ui.control.Slider
        SavePhotoButton        matlab.ui.control.Button
        BlueLabel              matlab.ui.control.Label
        BlueSlider             matlab.ui.control.Slider
        OGButton               matlab.ui.control.Button
        BWButton               matlab.ui.control.Button
        F1Button               matlab.ui.control.Button
        F2Button               matlab.ui.control.Button
        F3Button               matlab.ui.control.Button
        F4Button               matlab.ui.control.Button
        F5Button               matlab.ui.control.Button
        F6Button               matlab.ui.control.Button
        F7Button               matlab.ui.control.Button
        F8Button               matlab.ui.control.Button
        image                  % Displayed image mat
        image0                 % Image mat w sliders applied
        imagef                 % Image mat w filters applied
        filename               % Image file name
    end

    
    methods (Access = private)
        
        function updateimage(app, imagefile)
            app.filename = imagefile;
            
            % For corn.tif, read the second image in the file
            if strcmp(imagefile,'corn.tif')
                im = imread('corn.tif', 2);
            else
                try
                    im = imread(imagefile);
                catch ME
                    % If problem reading image, display error message
                    uialert(app.UIFigure, ME.message, 'Image Error');
                    return;
                end            
            end 
            
            % Create histograms based on number of color channels
            switch size(im,3)
                case 1
                    % Display the grayscale image
                    imagesc(app.ImageAxes,im);
                    
                case 3
                    % Display the truecolor image
                    imagesc(app.ImageAxes,im);
                    
                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Image must be grayscale or truecolor.', 'Image Error');
                    return;
            end
            
            % Set global image properties
            app.image = im;     % Displayed image mat
            app.image0 = im;    % Image mat w sliders applied
            app.imagef = im;    % Image mat w filters applied
                
        end
        
        function drawImage(app, im, key)
            % Draws the image in the UI after filter/slider applied
            
            % Key = 1 means filter, otherwise slider
            % Apply slider to filtered image, filtered to unfiltered image
            if key ~= 1
                app.image0 = im;
            else
                app.imagef = im;
            end
            
            % Draw image
            imagesc(app.ImageAxes,im);
            app.image = im;
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)
        
        % Code that executes after component creation
        function startupFcn(app)
            % Configure image axes
            app.ImageAxes.Visible = 'off';
            app.ImageAxes.Colormap = gray(256);
            axis(app.ImageAxes, 'image');
            
            % Update the image and histograms
            updateimage(app, 'peppers.png');
        end
        
        % Callback function
        function DropDownValueChanged(app, event)
            % Update the image
            updateimage(app, app.DropDown.Value);
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
               
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               fname = [p f];
               updateimage(app, fname);
            end
        end

        % Value changed function: BrightnessSlider
        function brightnessSlider(app, event)
            % Brightness slider function
            value = app.BrightnessSlider.Value - 50;
            im = app.imagef;
            im = im + value-50;          
            drawImage(app, im, 0);        
        end

        % Value changed function: RedSlider
        function rSlider(app, event)
            % Red slider tint function
            im = app.image;
            imf = app.imagef;
            
            value = round(app.RedSlider.Value);
            if value == 0
                value = 1;
            end
            
            r_values = imf(:,:,1);
            r_mean = round(mean(r_values, 'All'));
            r_range = map_values(r_mean,0,255);
            
            % map_values produces an array that represents the range of
            % values while value is the current value
            
            multiplier = r_range(value)/r_mean; % multiplier is the constant the color is multiplied by
            r_values_new(:,:) = round(r_values(:,:)*multiplier); % Recenters image
            
            im(:,:,1) = r_values_new;
            drawImage(app, im, 0); 
            % SLiders map app.image to app.image            
        end

        % Value changed function: GreenSlider
        function gSlider(app, event)
            % Green slider tint function
            value_g = round(app.GreenSlider.Value);
            im = app.image;
            imf = app.imagef;
            value = imf(:,:,2);
            if value == 0
                value = 1;
            end
            g_mean = round(mean(value, 'All'));
            g_range = map_values(g_mean,0,255);
            
            % map_values produces an array that represents the range of
            % values while value is the current value
            
            multiplier_g = g_range(value_g)/g_mean; % multiplier is the constant the color is multiplied by
            g_values_new(:,:) = round(value(:,:)*multiplier_g); % Recenters image
            
            im(:,:,2) = g_values_new;
            drawImage(app, im, 0); 
            % SLiders map app.image to app.image            
        end

        % Value changed function: BlueSlider
        function bSlider(app, event)
            % Blue slider tint function
            value = round(app.BlueSlider.Value);
            value_b = round(app.BlueSlider.Value);
            im = app.image;
            imf = app.imagef;
            value = imf(:,:,3);
            if value == 0
                value = 1;
            end
            b_mean = round(mean(value, 'All'));
            b_range = map_values(b_mean,0,255);
            
            % map_values produces an array that represents the range of
            % values while value is the current value
            
            multiplier_b = b_range(value_b)/b_mean; % multiplier is the constant the color is multiplied by
            b_values_new(:,:) = round(value(:,:)*multiplier_b); % Recenters image
            
            im(:,:,3) = b_values_new;
            drawImage(app, im, 0); 
            
        end

        % Button pushed function: SavePhotoButton
        function saveImage(app, event)
            % Save image to file using timestamp
            timeStamp = datestr(now,' yyyy.mm.dd HH.MM.SS.FFF');
            len = length(app.filename);
            name = app.filename(1:len-4); % Remove ext
            newName = strcat(name, timeStamp , '.png');
            
            % Write image to save file
            imwrite(app.image, newName);
        end

        % Button pushed function: OGButton
        function ogFilter(app, event)
            % Sets image to original, before filters applied
            app.image = app.image0;
            drawImage(app, app.image, 1);            
        end

        % Button pushed function: BWButton
        function bwFilter(app, event) 
            % Black and white filter
            % Calculate luminosity of image
            im0 = app.image0;
            im = 0.2989 * im0(:,:,1) + 0.5870 * im0(:,:,2) + 0.1140 * im0(:,:,3);
            drawImage(app, im, 1);      
        end

        % Button pushed function: F1Button
        function f1Filter(app, event)
            % Painting filter function
            % Takes image and rounds off pixels, grouping similar colors
            im0 = app.image0;
            im = round(im0/50)*50;
            drawImage(app, im, 1);
        end

        % Button pushed function: F2Button
        function f2Filter(app, event) 
            % Deep fry filter
            % First, sharpen the image
            im0 = app.image0;            
            kernel = [-1 -1 -1; -1 9 -1; -1 -1 -1];
            im0 = imfilter(im0, kernel);
            % Saturate the image
            HSV = rgb2hsv(im0);
            HSV(:, :, 2) = HSV(:, :, 2) * 1.75;
            HSV(HSV > 1) = 1;  % Limit values
            im0 = hsv2rgb(HSV);
            % Lower the quality
            [n, m, k] = size(im0);
            im = imresize(im0, [n/1.5 m/1.5]);
            % Sharpen again
            kernel = [-1 -1 -1; -1 9 -1; -1 -1 -1];
            im = imfilter(im, kernel);
            drawImage(app, im, 1);
        end

        % Button pushed function: F3Button
        function f3Filter(app, event) 
            %color Inversion
            im0 = app.image0;
            im = 255 - im0; %subtract all color values from 255 to get negative effect
            drawImage(app, im, 1);
        end

        % Button pushed function: F4Button
        function f4Filter(app, event) 
            %Mirror tool
            im0 = app.image0;
            
            im=uint8(zeros(size(im0)));     %Make temporary copy of im0
%             but with zero values

            R=fliplr(im0(:,:,1));       %flip individual color matrices
            G=fliplr(im0(:,:,2));
            B=fliplr(im0(:,:,3));

            im(:,:,1)=R;        %replace the copy from before with the flipped values to produce mirrored image
            im(:,:,2)=G;
            im(:,:,3)=B;
            drawImage(app, im, 1);
        end

        % Button pushed function: F5Button
        function f5Filter(app, event) 
            im0 = app.image0;
            %im = 0.2989 * im0(:,:,1) + 0.5870 * im0(:,:,2) + 0.1140 * im0(:,:,3);
            kernel = [ -2 0 0; %glowing edges kernel
                    0 0 0;
                    0 0 2]; 
            %kernel = [0 0 0; 1 0 -1; 0 0 0];
            %kernel = [1 0 0; 0 0 0; 0 0 -1];
            im = imfilter(im0, kernel);
            drawImage(app, im, 1);
        end

        % Button pushed function: F6Button
        function f6Filter(app, event) 
            im0 = app.image0;
            im = 0.2989 * im0(:,:,1) + 0.5870 * im0(:,:,2) + 0.1140 * im0(:,:,3);
            mid = 120;
            %imshow(I) %values from 0 255
            im(find(mid>im)) = 0;
            im(find(mid<im)) = 255;
            drawImage(app, im, 1);
            
        end

        % Button pushed function: F7Button
        function f7Filter(app, event) 
            
            % Color Inversion            
            im0 = app.image0;
            HSV_vec = rgb2hsv(im0);                 
            H = HSV_vec(:,:,1);
            H = mod(round(H*360 + 180), 360);
            H = H/360;
            HSV_vec(:,:,1) = H;
            RGB_new = hsv2rgb(HSV_vec);
            im(:,:,1) = RGB_new(:,:,1);
            im(:,:,2) = RGB_new(:,:,2);
            im(:,:,3) = RGB_new(:,:,3);
            %imshow(im)
            drawImage(app, im, 1);
                      
        end

        % Button pushed function: F8Button
        function f8Filter(app, event) 
            im0 = app.image0;
         
            im = 0.2989 * im0(:,:,1) + 0.5870 * im0(:,:,2) + 0.1140 * im0(:,:,3);
            kernel = [ -2 -1 0; %embossed
                    -1 2 1;
                    0 1 2]; 
            %kernel = [-3 -1 0 0 0 0; -1 -1 0 0 0; 0 0 0 0 0; 0 0 0 1 1; 0 0 0 1 3];
            im = imfilter(im, kernel);
            drawImage(app, im, 1);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 836 626];
            app.UIFigure.Name = 'Picture Perfect Philters';
            app.UIFigure.Resize = 'off';

            % Create ImageAxes
            app.ImageAxes = uiaxes(app.UIFigure);
            app.ImageAxes.XTick = [];
            app.ImageAxes.XTickLabel = {'[ ]'};
            app.ImageAxes.YTick = [];
            app.ImageAxes.Position = [45 211 464 352];

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [45 163 464 22];
            app.LoadButton.Text = 'Load Custom Image';

            % Create BrightnessSliderLabel
            app.BrightnessSliderLabel = uilabel(app.UIFigure);
            app.BrightnessSliderLabel.HorizontalAlignment = 'right';
            app.BrightnessSliderLabel.Position = [545 484 62 22];
            app.BrightnessSliderLabel.Text = 'Brightness';

            % Create BrightnessSlider
            app.BrightnessSlider = uislider(app.UIFigure, 'Value', 50); % Resets the start value of slider
            app.BrightnessSlider.ValueChangedFcn = createCallbackFcn(app, @brightnessSlider, true);
            app.BrightnessSlider.Position = [628 493 150 3];

            % Create RedSliderLabel
            app.RedSliderLabel = uilabel(app.UIFigure);
            app.RedSliderLabel.HorizontalAlignment = 'right';
            %app.RedSliderLabel.Value = 50;
            app.RedSliderLabel.Position = [582 422 28 22];
            app.RedSliderLabel.Text = 'Red';

            % Create RedSlider
            app.RedSlider = uislider(app.UIFigure, 'Value', 50); % Resets the start value of slider
            app.RedSlider.ValueChangedFcn = createCallbackFcn(app, @rSlider, true);
            app.RedSlider.Position = [631 431 150 3];

            % Create GreenSliderLabel
            app.GreenSliderLabel = uilabel(app.UIFigure); % Resets the start value of slider
            app.GreenSliderLabel.HorizontalAlignment = 'right';
            app.GreenSliderLabel.Position = [573 360 39 22];
            app.GreenSliderLabel.Text = 'Green';

            % Create GreenSlider
            app.GreenSlider = uislider(app.UIFigure, 'Value', 50);
            app.GreenSlider.ValueChangedFcn = createCallbackFcn(app, @gSlider, true);
            app.GreenSlider.Position = [633 369 150 3];

            % Create SavePhotoButton
            app.SavePhotoButton = uibutton(app.UIFigure, 'push');
            app.SavePhotoButton.ButtonPushedFcn = createCallbackFcn(app, @saveImage, true);
            app.SavePhotoButton.Position = [45 129 464 22];
            app.SavePhotoButton.Text = 'Save Photo';

            % Create BlueLabel
            app.BlueLabel = uilabel(app.UIFigure);
            app.BlueLabel.HorizontalAlignment = 'right';
            app.BlueLabel.Position = [582 299 30 22];
            app.BlueLabel.Text = 'Blue';

            % Create BlueSlider
            app.BlueSlider = uislider(app.UIFigure, 'Value', 50);
            app.BlueSlider.ValueChangedFcn = createCallbackFcn(app, @bSlider, true);
            app.BlueSlider.Position = [633 308 150 3];

            % Create Original Image Button
            app.OGButton = uibutton(app.UIFigure, 'push');
            app.OGButton.ButtonPushedFcn = createCallbackFcn(app, @ogFilter, true);
            app.OGButton.BackgroundColor = [0.45 0.45 0.45];
            app.OGButton.FontWeight = 'bold';
            app.OGButton.FontColor = [1 1 1];
            app.OGButton.Position = [45 39 64 61];
            app.OGButton.Text = 'OG';

            % Create BWButton
            app.BWButton = uibutton(app.UIFigure, 'push');
            app.BWButton.ButtonPushedFcn = createCallbackFcn(app, @bwFilter, true);
            app.BWButton.BackgroundColor = [0.149 0.149 0.149];
            app.BWButton.FontWeight = 'bold';
            app.BWButton.FontColor = [1 1 1];
            app.BWButton.Position = [120 39 64 61];
            app.BWButton.Text = 'B&W';

            % Create Filter #1 Button
            app.F1Button = uibutton(app.UIFigure, 'push');
            app.F1Button.ButtonPushedFcn = createCallbackFcn(app, @f1Filter, true);
            app.F1Button.BackgroundColor = [0.75 0.15 0.75];
            app.F1Button.FontWeight = 'bold';
            app.F1Button.FontColor = [1 1 1];
            app.F1Button.Position = [195 39 64 61];
            app.F1Button.Text = 'Painted';

            % Create Filter #2 Button
            app.F2Button = uibutton(app.UIFigure, 'push');
            app.F2Button.ButtonPushedFcn = createCallbackFcn(app, @f2Filter, true);
            app.F2Button.BackgroundColor = [0.9 0.8 0];
            app.F2Button.FontWeight = 'bold';
            app.F2Button.FontColor = [1 1 1];
            app.F2Button.Position = [270 39 64 61];
            app.F2Button.Text = 'Fry';

            % Create Filter #3 Button
            app.F3Button = uibutton(app.UIFigure, 'push');
            app.F3Button.ButtonPushedFcn = createCallbackFcn(app, @f3Filter, true);
            app.F3Button.BackgroundColor = [0.05 0.05 0.85];
            app.F3Button.FontWeight = 'bold';
            app.F3Button.FontColor = [1 1 1];
            app.F3Button.Position = [345 39 64 61];
            app.F3Button.Text = 'Invert';

            % Create Filter #4 Button
            app.F4Button = uibutton(app.UIFigure, 'push');
            app.F4Button.ButtonPushedFcn = createCallbackFcn(app, @f4Filter, true);
            app.F4Button.BackgroundColor = [0.15 0.85 0.95];
            app.F4Button.FontWeight = 'bold';
            app.F4Button.FontColor = [1 1 1];
            app.F4Button.Position = [420 39 64 61];
            app.F4Button.Text = 'Mirror';

            % Create Filter #5 Button
            app.F5Button = uibutton(app.UIFigure, 'push');
            app.F5Button.ButtonPushedFcn = createCallbackFcn(app, @f5Filter, true);
            app.F5Button.BackgroundColor = [0.45 0.45 0.85];
            app.F5Button.FontWeight = 'bold';
            app.F5Button.FontColor = [1 1 1];
            app.F5Button.Position = [495 39 64 61];
            app.F5Button.Text = 'Glow';

            % Create Filter #6 Button
            app.F6Button = uibutton(app.UIFigure, 'push');
            app.F6Button.ButtonPushedFcn = createCallbackFcn(app, @f6Filter, true);
            app.F6Button.BackgroundColor = [0.25 0.95 0.45];
            app.F6Button.FontWeight = 'bold';
            app.F6Button.FontColor = [1 1 1];
            app.F6Button.Position = [570 39 64 61];
            app.F6Button.Text = 'Bipolar';

            % Create Filter #7 Button
            app.F7Button = uibutton(app.UIFigure, 'push');
            app.F7Button.ButtonPushedFcn = createCallbackFcn(app, @f7Filter, true);
            app.F7Button.BackgroundColor = [0.9 0.4 0.5];
            app.F7Button.FontWeight = 'bold';
            app.F7Button.FontColor = [1 1 1];
            app.F7Button.Position = [645 39 64 61];
            app.F7Button.Text = 'Hue';

            % Create Filter #8 Button
            app.F8Button = uibutton(app.UIFigure, 'push');
            app.F8Button.ButtonPushedFcn = createCallbackFcn(app, @f8Filter, true);
            app.F8Button.BackgroundColor = [0.25 0.95 0.82];
            app.F8Button.FontWeight = 'bold';
            app.F8Button.FontColor = [1 1 1];
            app.F8Button.Position = [720 39 64 61];
            app.F8Button.Text = 'Emboss';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = PicturePerfectPhotoPhilter

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end

function mapped_values = map_values(average, min_r, max_r)
    
    % current_v = 70;  % Current increment the slider is at
    % average =  50;   % The average value of the set 
    % min_r = 0;       % The minimum range for the desired range of values can be rgb lum etc.
    % max_r = 255;     % The maximum range for the desired range of values can be rgb lum etc.
    
    min_slider = 0;  % The minimum slider val
    max_slider = 100;% The maximum slider val 
    increment_values = min_slider:1:max_slider; %range of slider
    upper_half = round(linspace(average,max_r,50)); % Rounded values for each remap
    lower_half = round(linspace(min_r,average,50));   % Rounded values for each remap
    mapped_values = [lower_half upper_half]; % Concatanates arrays. Values are not equally distr. But slider should work
end
