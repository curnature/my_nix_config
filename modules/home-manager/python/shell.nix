{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
            ];

    home.devShells = {
        python = {
            packages = with pkgs; [
                python312Full
                python312Packages.numpy
                python312Packages.pandas
                python312Packages.matplotlib
                # Add any other Python packages you need here

            ];

        };


    };



}
