{
    description = "NixOS and Home Manager configuration using Flake";

    inputs = {
        # specify the source of nixpkgs. unstable branch for the latest version of pkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        # options for nixpkgs
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
        # specify the source of home-manager. managing user configurations
        home-manager = {
            url = "github:nix-community/home-manager/master"; # unstable
            # url = "github:nix-community/home-manager/release-24.11"; # stable
            
            # make pkgs consistent with nixpkgs
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # home=manager version options: 
        # https://github.com/nix-community/home-manager/blob/master/modules/misc/version.nix
        
        # nixos profiles to optimize settings for different hardware
        nixos-hardware.url = "github:NixOS/nixos-hardware";

        #
        nixvim = {
            url = "github:nix-community/nixvim";
            # 
            inputs.nixpkgs.follows = "nixpkgs";
        }; 
    };

    outputs = { 
        self, 
        nixpkgs, 
        home-manager, 
        nixos-hardware,
        ... 
    }@inputs: let
        # temporarily store system variables. may remove later when figuring out a better way
        systemVariables = import ./systemVariables.nix;
        
        # specify system type, username. hostname, nixosVersion, homeVersion
        system = systemVariables.system;
        user = systemVariables.username;
        hosts = [
            { hostname = systemVariables.hostname; stateVersion = systemVariables.nixVersion; }
        ];
        homeStateVersion = systemVariables.homeVersion;
        
        # make pkgs consistent with nixpkgs
        pkgs = import nixpkgs { inherit system; };
        
        # transfer parameters to "nixosConfigurations"
        makeSystem = { hostname, stateVersion }: nixpkgs.lib.nixosSystem {
            # keep using parameters defined above
            system = system;
            specialArgs = {
                inherit inputs stateVersion hostname user;
            };
            
            # load main nixos config, other modules loaded in configuration.nix
            modules = [
                ./hosts/${systemVariables.hostname}/configuration.nix 
            ];
        };
            
    in {
        #----------------------------------------------------------------
        nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
            configs // {
                "${host.hostname}" = makeSystem {
                    inherit (host) hostname stateVersion;
                };
            }) {} hosts;
        
        #----------------------------------------------------------------
        homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
                inherit inputs homeStateVersion user;
            };
            # load main home-manager config, other modules loaded in home.nix
            modules = [
                ./home-manager/home.nix
            ];
        };
        #----------------------------------------------------------------
        # python shell
        devShells.${system}.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
                coreutils
                util-linux
                findutils
                gawk
                # all python packages inside "withPackages"
                (python3.withPackages (ps: with ps; [
                    numpy
                    dbus-python
                    ]) 
                )
            ];
            # indicates the shell
            shellHook = ''
                echo "Welcome to my Python shell!" | ${pkgs.lolcat}/bin/lolcat
                trap 'echo "Exiting my Python shell!" | ${pkgs.lolcat}/bin/lolcat' EXIT
            '';

            COLOR = "blue";
        };
        #----------------------------------------------------------------

    };
}

