{
    description = "NixOS and Home Manager configuration using Flake";

    inputs = {
        # Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
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
        systemVariables = import ./systemVariables.nix;
        system = systemVariables.system;
        user = systemVariables.username;
        hosts = [
            { hostname = systemVariables.hostname; stateVersion = systemVariables.nixVersion; }
        ];
        homeStateVersion = systemVariables.homeVersion;

        pkgs = import nixpkgs { inherit system; };

        makeSystem = { hostname, stateVersion }: nixpkgs.lib.nixosSystem {
            system = system;
            specialArgs = {
                inherit inputs stateVersion hostname user;
            };

            modules = [
                ./hosts/${systemVariables.hostname}/configuration.nix 
            ];

        };
            
    in {
        nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
            configs // {
                "${host.hostname}" = makeSystem {
                    inherit (host) hostname stateVersion;
                };
            }) {} hosts;

        homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
                inherit inputs homeStateVersion user;
            };

            modules = [
                ./home-manager/home.nix
            ];
        };

    };
}

