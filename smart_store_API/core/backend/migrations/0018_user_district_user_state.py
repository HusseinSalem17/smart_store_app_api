# Generated by Django 4.2.7 on 2024-01-18 14:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backend', '0017_user_address_user_contact_no_user_name_user_pincode'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='district',
            field=models.CharField(default='fdfa', max_length=500),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='user',
            name='state',
            field=models.CharField(default='dfsasdf', max_length=500),
            preserve_default=False,
        ),
    ]
