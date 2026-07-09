import { randomBytes } from 'crypto';
import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  BeforeInsert,
} from 'typeorm';
import { CategoryColor } from './category-color';

@Entity('categories')
export class Category {
  @PrimaryColumn({ type: 'varchar' })
  id!: string;

  @Column({ unique: true })
  catDesc!: string;

  @Column()
  catEmoji!: string;

  @Column({
    type: 'enum',
    enum: CategoryColor,
    default: CategoryColor.red,
  })
  catColor!: CategoryColor;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  @BeforeInsert()
  generateId() {
    this.id = randomBytes(16).toString('hex');
  }
}
