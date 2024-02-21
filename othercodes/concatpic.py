from PIL import Image

def merge_images_horizontally(images):
    widths, heights = zip(*(i.size for i in images))

    total_width = sum(widths)
    max_height = max(heights)

    merged_image = Image.new('RGBA', (total_width, max_height))

    x_offset = 0
    for image in images:
        merged_image.paste(image, (x_offset, 0))
        x_offset += image.width

    return merged_image

images = [Image.open('D:\Godot\Projects\Dice3\Art\Picture\dice/burning/burning_start_1.png'), Image.open('D:\Godot\Projects\Dice3\Art\Picture\dice\\burning/burning_loop_1.png')]

merged_image = merge_images_horizontally(images)

merged_image.save('D:\Godot\Projects\Dice3\Art\Picture\dice/burning\merged_image.png')