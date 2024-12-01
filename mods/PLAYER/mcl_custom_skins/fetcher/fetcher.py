import requests
import os
import sys
from PIL import Image

def fetch_skin(username):
    # Step 1: Get UUID
    uuid_response = requests.get(f"https://api.mojang.com/users/profiles/minecraft/{username}")
    uuid_response.raise_for_status()
    uuid = uuid_response.json()["id"]

    # Step 3: Extract skin URL from crafatar using uuid
    skin_response = requests.get(f"https://crafatar.com/skins/{uuid}")
    skin_response.raise_for_status()
    skin_data = skin_response.content

    # Step 3: Save skin to file (../textures/ relative to this file)
    skin_path = os.path.join(os.path.dirname(__file__), "..", "textures", f"{username}.png")
    with open(skin_path, "wb") as f:
        f.write(skin_data)

    # Step 4: Crop skin to 64x32 from top left corner
    skin = Image.open(skin_path)
    skin = skin.crop((0, 0, 64, 32))
    skin.save(skin_path)

    # Step 5: If the skin should be used with the slim-armed player mesh, include a complimentary file in the `../meta/` directory. The file in the meta directory should have the same name as the texture with the file extension changed to `.txt`. Add the line to the file `gender="female",`.
    # there should be empty pixels at positions (50, 16) to (52, 20) in the skin texture
    if skin.getpixel((50, 16)) == (0, 0, 0, 0) and skin.getpixel((51, 16)) == (0, 0, 0, 0) and skin.getpixel((52, 16)) == (0, 0, 0, 0) and skin.getpixel((50, 17)) == (0, 0, 0, 0) and skin.getpixel((51, 17)) == (0, 0, 0, 0) and skin.getpixel((52, 17)) == (0, 0, 0, 0) and skin.getpixel((50, 18)) == (0, 0, 0, 0) and skin.getpixel((51, 18)) == (0, 0, 0, 0) and skin.getpixel((52, 18)) == (0, 0, 0, 0) and skin.getpixel((50, 19)) == (0, 0, 0, 0) and skin.getpixel((51, 19)) == (0, 0, 0, 0) and skin.getpixel((52, 19)) == (0, 0, 0, 0):
        with open(os.path.join(os.path.dirname(__file__), "..", "meta", f"{username}.txt"), "w") as f:
            f.write('gender="female"\n')


    # Step 5: Check if the skin is valid
    try:
        Image.open(skin_path)
    except:
        os.remove(skin_path)
        return None
    
    return skin_path



if __name__ == "__main__":
    username = sys.argv[1]
    skin_path = fetch_skin(username)
    if skin_path:
        print(skin_path)
    else:
        sys.exit(1)