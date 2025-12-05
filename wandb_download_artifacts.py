import os
import wandb
import argparse


TYPE = "model"


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("--project", type=str, required=True)
    args = parser.parse_args()
    project = args.project

    download_root_path = os.path.expanduser(f"~/Desktop/wandb_data__{project}/")
    api = wandb.Api()
    collections = [coll for coll in api.artifact_type(type_name=TYPE, project=project).collections()]

    total_downloaded_size_gb = 0
    for coll in collections:

        print(coll)
        
        for artifact in coll.versions():

            print(f"  artifact:", artifact, artifact.name, artifact.aliases, end="")
            total_downloaded_size_gb += artifact.size * 9.313225746154785e-10

            root_filepath = os.path.join(download_root_path, artifact.name)
            artifact.download(root=root_filepath)
                

    print(f"\nTotal size of data downloade: {round(total_downloaded_size_gb, 2)}gb")