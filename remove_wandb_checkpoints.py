import wandb
import argparse


# Delete non final artifacts
TYPE = "model"
TO_KEEP_ALIASES = ["best_k", "latest"]


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("--project", type=str, required=True)
    args = parser.parse_args()
    project = args.project

    api = wandb.Api()
    collections = [coll for coll in api.artifact_type(type_name=TYPE, project=project).collections()]

    # aliases = set()
    for coll in collections:

        print(f"collection: {coll}")
        
        for artifact in coll.versions():

            print(f"  artifact:", artifact, artifact.name, artifact.aliases, end="")

            if any([x in artifact.aliases for x in TO_KEEP_ALIASES]):                
                print(" - KEEPING")
            else:
                artifact.delete()
                print(" - DELETED")

    print(f"\ncollections")
    print(collections)