{
    description = "NixOS and Home Manager configuration using Flake";

    inputs = {
        # Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixos-hardware.url = "github:NixOS/nixos-hardware";
    };

    outputs = { 
        self, 
        nixpkgs, 
        home-manager, 
        nixos-hardware, 
        ... 
    }@inputs: let
        system = "x86_64-linux";
        user = "curvature";
        hosts = [
            { hostname = "nixnoob"; stateVersion = "24.11"; }
        ];

        pkgs = import nixpkgs { inherit system; };

        makeSystem = { hostname, stateVersion }: nixpkgs.lib.nixosSystem {
            system = system;
            specialArgs = {
                inherit inputs stateVersion hostname user;
            };

            modules = [
                ./hosts/nixnoob/configuration.nix
                ./hosts/nixnoob/hardware-configuration.nix
            ];

        };
            
    in {
        nixosConfigurations = {
            nixnoob = makeSystem { hostname = "nixnoob"; stateVersion = "24.11"; };
        };

        homeConfigurations = {
            curvature = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;

                modules = [ 
                    ./home-manager/home.nix 
                ];
                # Optionally use extraSpecialArgs
                # to pass through arguments to home.nix
            };
        };
    };
}

