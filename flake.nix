{
  description = "qbisi's flake templates";

  outputs =
    { self }:
    {

      templates = {
        default = self.templates.packages;
        packages = {
          path = ./packages;
          description = "template for flake packages set with overlay module";
        };
      };

    };
}
