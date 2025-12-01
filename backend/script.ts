import { prisma } from "./lib/prisma";

async function main() {
  // Create a new user with a post
  const user = await prisma.user.create({
    data: {
      name: "KOUSSOUGBO Melanie",
      email: "melanie.koussougbo@gmail.com",
      password: "Admin123",
    },
    include: {
      properties: true,
    },
  });
  // create a new property for the user
  const property = await prisma.property.create({
    data: {
      title: "bureau Melanie-Coworking",
      description:
        "Espace de coworking moderne et convivial, idéal pour les professionnels en quête d'un environnement de travail stimulant et collaboratif.",
      price: 66200000,
      address: "Avenue des Forges, Lomé",
      type: "BUREAU",
      city: "Lomé",
      surface: 50,
      zipCode: "12345",
      images: ["assets/bureau01.jpg"],
      sellerId: user.id,
    },
  });
  console.log("Created property:", property);
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
