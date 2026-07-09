import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsString } from 'class-validator';
import { CategoryColor } from '../entities/category-color';

export class CreateCategoryDto {
  @ApiProperty({ example: 'Electronics' })
  @IsString()
  catDesc!: string;

  @ApiProperty({ example: '📱' })
  @IsString()
  catEmoji!: string;

  @ApiProperty({
    enum: CategoryColor,
    example: 'red|blue|green|yellow|purple',
  })
  @IsEnum(CategoryColor)
  catColor!: CategoryColor;
}
